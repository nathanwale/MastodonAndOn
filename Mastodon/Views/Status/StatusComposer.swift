//
//  StatusComposer.swift
//  Mastodon
//
//  Created by Nathan Wale on 15/3/2024.
//

import SwiftUI

///
/// A view to compose a Status
///
struct StatusComposer: View
{
    /// Instance host
    let instanceHost = Config.shared.activeInstanceHost
    
    /// Access token
    let accessToken = Config.shared.accessToken
    
    /// App navigation
    @EnvironmentObject var navigation: AppNavigation
    
    /// Function to dismiss this view
    @Environment(\.dismiss) var dismiss
    
    /// Editing context
    private var context: Context = .new
    
    /// Content of post
    @State var content = ""
    
    /// Add a content warning?
    @State var hasContentWarning = false
    
    /// Content Warning Message
    @State var contentWarningMessage = ""
    
    /// Character count
    @State var remainingCharacters = StatusCharacterCounter.maxCharacters
    
    /// Lookup State
    @State var lookupState: LookupState = .none
    
    /// Lookup results
    @State var lookupResults: [LookupResult] = []
    
    /// Posting error if exists
    @State var postingError: Error?
    
    /// Are we fetching lookup values?
    @State var isFetchingLookup = false
    
    /// Focus state
    @FocusState var textFieldFocused: Bool
    
    /// Character counter
    let counter = StatusCharacterCounter()
    
    /// Cancel action
    let onCancel: (() -> ())?
    
    // MARK: - inits
    /// Init with new Status
    init(onCancel: @escaping () -> ()) {
        self.onCancel = onCancel
    }
    
    /// Init replying to Status
    init(replyingTo: MastodonStatus)
    {
        context = .replying(replyingTo)
        onCancel = nil
    }
    
    /// Init editing Status
    init(editing: MastodonStatus)
    {
        context = .editing(editing)
        
        // Parse and assign status content
        let parsedString = ParsedText(html: editing.content).string ?? ""
        _content = .init(initialValue: parsedString)
        
        onCancel = nil
        
    }
    
    
    // MARK: - funcs
    /// Remaining characters message
    var remainingCharactersMessage: String
    {
        let characters = (remainingCharacters.magnitude == 1)
            ? "character"
            : "characters"
        
        if remainingCharacters >= 0 {
            return "\(remainingCharacters) \(characters) left"
        } else {
            return "\(remainingCharacters.magnitude) \(characters) too many!"
        }
    }
    
    
    // MARK: - functions
    /// Count characters
    func updateCharacterCount()
    {
        remainingCharacters = counter.remainingCharacters(content)
    }
    
    /// Handle text input
    func characterWasEntered()
    {
        guard let character = content.last else {
            // Reset state if `content` is empty
            lookupState = .none
            return
        }
        
        // count characters
        updateCharacterCount()
        
        // check if we should be looking something up
        switch (character, lookupState)
        {
            // Pressed @, we've started a mention
            case ("@", _):
                lookupState = .mention(nil)

            // Pressed #, started a hashtag
            case ("#", _):
                lookupState = .hashtag(nil)
                 
            // Lookup cancelled
            case (" ", _):
                lookupState = .none
                
            // Add to mention lookup
            case (_, .mention):
                lookupState = .mention(findSuffix("@"))
                
            // Add to hashtag lookup
            case (_, .hashtag):
                lookupState = .hashtag(findSuffix("#"))
                
            default:
                break
        }
    }
    
    /// Handle lookup if required
    func lookup() async throws
    {
        var request: (any LookupRequest)? = nil
        switch lookupState
        {
            // do nothing
            case .none:
                break
                
            // look up hashtag if it's at least two characters
            case .hashtag(let tagFragment):
                if let tagFragment {
                    request = HashtagLookupRequest(
                        host: instanceHost,
                        searchTerm: tagFragment,
                        accessToken: accessToken)
                }
                
            // look up mention if it's at least two characters
            case .mention(let mentionFragment):
                if let mentionFragment {
                    request = MentionLookupRequest(
                        host: instanceHost,
                        searchTerm: mentionFragment,
                        accessToken: accessToken)
                }
        }
        
        // We should perform lookup if request is no longer nil
        if let request {
            isFetchingLookup = true
            lookupResults = try await request.lookup()
            isFetchingLookup = false
        } else {
            lookupResults = []
        }
    }
    
    /// Find text suffix and return, else return whole string
    func findSuffix(_ character: Character) -> String?
    {
        // If we can't find the character, or if there's nothing after it,
        // return nil
        guard
            let charindex = content.lastIndex(of: character),
            let index = content.index(charindex, offsetBy: 1, limitedBy: content.endIndex)
        else {
            return nil
        }
        
        let result = String(content[index...])
        
        // return result if longer than two characters, else nil
        return result.count >= 3
            ? result
            : nil
    }
    
    /// Replace suffix in content
    func replaceLast(symbol: Character, replacement: String)
    {
        guard
            let index = content.lastIndex(of: symbol)
        else {
            return
        }
        
        content.replaceSubrange(index..., with: "\(symbol)\(replacement)")
        lookupResults = []
        lookupState = .none
    }
    
    /// Post status
    func postStatus() async throws
    {
        _ = switch context
        {
            // Status is new
            case .new:
                try await NewStatusRequest(
                    host: instanceHost,
                    accessToken: accessToken,
                    statusContent: content,
                    isSensitive: hasContentWarning,
                    spoilerText: contentWarningMessage).send()
            
            // Status is replying to another
            case .replying(let status):
                try await NewStatusRequest(
                    host: instanceHost,
                    accessToken: accessToken,
                    statusContent: content,
                    replyStatusId: status.id,
                    isSensitive: hasContentWarning,
                    spoilerText: contentWarningMessage).send()
                
            // Editing status
            case .editing(let status):
                try await EditStatusRequest(
                    statusId: status.id,
                    host: instanceHost,
                    accessToken: accessToken,
                    statusContent: content,
                    replyStatusId: status.inReplyToId,
                    isSensitive: hasContentWarning,
                    spoilerText: contentWarningMessage).send()
        }
    }
    
    
    // MARK: - subviews
    var body: some View
    {
        ScrollView
        {
            VStack
            {
                cancelButton
                header
                if hasContentWarning {
                    contentWarningTextField
                }
                contentTextField
                if postingError != nil {
                    postingErrorMessage
                }
                postButton
                if isFetchingLookup {
                    ProgressView()
                }
                lookupMenu
                replyingToStatusView
            }
            .padding()
            .onAppear {
                updateCharacterCount()
                textFieldFocused = true
            }
            .onChange(of: lookupState) {
                Task {
                    do {
                        try await lookup()
                    } catch {
                        print("Lookup error: \(error)")
                    }
                }
            }
        }
    }
    
    /// Cancel button
    @ViewBuilder
    var cancelButton: some View
    {
        if let onCancel {
            HStack
            {
                Button
                {
                    onCancel()
                } label: {
                    Icon.cancel.image
                        .font(.title)
                }
                
                Spacer()
            }
        }
    }
    
    /// Header text
    var header: some View
    {
        HStack
        {
            let description = switch context {
                case .new:
                    "New post"
                case .editing:
                    "Editing your post"
                case .replying(let status):
                    "Replying to \(status.account.displayName ?? "post")"
            }
            
            Text(description).font(.headline)
            Spacer()
            contentWarningSwitch
        }
    }
    
    /// Text field for post content
    var contentTextField: some View
    {
        TextField("Post content", text: $content, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .lineLimit(7, reservesSpace: true)
            .focused($textFieldFocused, equals: true)
            .onKeyPress(phases: .up) {
                _ in
                characterWasEntered()
                return .ignored
            }
    }
    
    /// Button for posting post
    var postButton: some View
    {
        HStack
        {
            Text(remainingCharactersMessage)
            Spacer()
            Button("Post!", systemImage: Icon.send.rawValue)
            {
                Task
                {
                    do {
                        try await postStatus()
                        print("post successful!")
                        switch context {
                            case .new:
                                dismiss()
                            case .replying, .editing:
                                navigation.pop()
                        }
                    } catch {
                        print(error)
                        postingError = error
                    }
                }
            }
            .disabled(remainingCharacters < 0)
        }
        .buttonStyle(.borderedProminent)
    }
    
    /// Content Warning Switch
    var contentWarningSwitch: some View
    {
        Toggle(isOn: $hasContentWarning)
        {
            Text("Add Warning")
        }
        .toggleStyle(.button)
    }
    
    /// Content warning text field
    var contentWarningTextField: some View
    {
        VStack(alignment: .leading)
        {
            HStack
            {
                Icon.contentWarning.image.font(.title)
                Text("Your content will be obscured, and show this warning.")
            }
            TextField("Content warning", text: $contentWarningMessage)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
        .background(.primary.opacity(0.1))
    }
    
    /// Lookup menu
    var lookupMenu: some View
    {
        VStack(spacing: 1)
        {
            if !lookupResults.isEmpty
            {
                let lookupName = switch lookupState {
                case .none:
                    ""
                case .hashtag(let tag):
                    "Tags beginning with \(tag ?? "")"
                case .mention(let mention):
                    "Accounts beginning with \(mention ?? "")"
                }
                
                Text(lookupName).font(.headline)
            }
            
            ForEach(lookupResults)
            {
                result in
                lookupMenuItem(result)
                .padding(5)
                .background(Color.primary.opacity(0.1))
            }
        }
    }
    
    /// Lookup menu item
    @ViewBuilder
    func lookupMenuItem(_ item: LookupResult) -> some View
    {
        switch item {
            // Is a mention
            case .mention(let mastodonAccount):
                mentionMenuItem(mastodonAccount)
                
            // Is a hashtag
            case .hashtag(let tag, let count):
                hashtagMenuItem(tag: tag, count: count)
        }
    }
    
    /// Mention menu item
    func mentionMenuItem(_ account: MastodonAccount) -> some View
    {
        HStack
        {
            ProfileImage(url: account.avatar, size: .status)
            VStack(alignment: .leading)
            {
                Text("@").foregroundStyle(.gray) + Text(account.acct).font(.headline)
                Text(account.displayName)
            }
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            replaceLast(symbol: "@", replacement: account.acct)
        }
    }
    
    /// Hashtag menu item
    func hashtagMenuItem(tag: String, count: Int) -> some View
    {
        HStack
        {
            Text("#").foregroundStyle(.gray) + Text(tag).font(.headline)
            Spacer()
            Text(String(count))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            replaceLast(symbol: "#", replacement: tag)
        }
    }
    
    /// Posting error message
    var postingErrorMessage: some View
    {
        HStack(alignment: .top)
        {
            // Error icon
            Icon.error.image
                .font(.title)
                .padding(.top, 5)
            
            // Messages
            VStack(alignment: .leading)
            {
                Text("There was an error posting").font(.headline)
                Text(postingError?.localizedDescription ?? "")
            }
        }
        .padding()
        .background(Color.yellow.opacity(0.5))
    }
    
    /// Replying to Status view
    @ViewBuilder
    var replyingToStatusView: some View
    {
        switch context
        {
            case .replying(let status):
                VStack(alignment: .leading)
                {
                    Text("Replying to:").font(.headline)
                    StatusPost(status, showToolBar: false)
                        .padding(.vertical, 10)
                        .background(Color.primary.opacity(0.1))
                }
                
            default:
                EmptyView()
        }
    }
}


// MARK: - subtypes
extension StatusComposer
{
    ///
    /// Represents whether we should look up something
    /// as the user types
    ///
    enum LookupState: Equatable
    {
        /// Don't look up anything
        case none
        
        /// We have a term to lookup hashtags
        case hashtag(String?)
        
        /// We have a term to lookup mentions
        case mention(String?)
        
        /// The symbol representing the lookup
        /// eg. `#` for .hashtag, `@` for .mention
        var symbol: String
        {
            switch self {
                case .hashtag: "#"
                case .mention: "@"
                case .none: ""
            }
        }
    }
    
    ///
    /// What type of Status are we editing
    ///
    enum Context
    {
        /// A new Status
        case new
        
        /// Replying to a Status
        case replying(MastodonStatus)
        
        /// Editing a Status
        case editing(MastodonStatus)
    }
}

// MARK: - previews
#Preview("New status") 
{
    StatusComposer() {
        print("Cancelled!")
    }
}

#Preview("Replying")
{
    StatusComposer(replyingTo: .preview)
}

#Preview("Editing")
{
    StatusComposer(editing: .preview)
}
