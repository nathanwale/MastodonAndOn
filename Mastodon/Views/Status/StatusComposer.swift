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
    
    /// Function to dismiss this view
    @Environment(\.dismiss) var dismiss
    
    /// Reply to ID if applicable, else nil
    var replyStatus: MastodonStatus?
    
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
    
    /// Character counter
    let counter = StatusCharacterCounter()
    
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
            lookupResults = try await request.lookup()
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
    }
    
    /// Post status
    func postStatus() async throws
    {
        let request = NewStatusRequest(
            host: instanceHost,
            accessToken: accessToken,
            statusContent: content,
            replyStatusId: replyStatus?.id,
            isSensitive: hasContentWarning,
            spoilerText: contentWarningMessage)
        
        _ = try await request.send()
    }
    
    
    // MARK: - subviews
    var body: some View
    {
        ScrollView
        {
            VStack
            {
                header
                if hasContentWarning {
                    contentWarningTextField
                }
                contentTextField
                if postingError != nil {
                    postingErrorMessage
                }
                postButton
                lookupMenu
                replyingToStatusView
            }
            .padding()
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
    
    /// Header text
    var header: some View
    {
        HStack
        {
            if replyStatus == nil {
                Text("New post").font(.headline)
            }
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
                        dismiss()
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
            let lookupName = switch lookupState {
                case .none:
                    ""
                case .hashtag(let tag):
                    "Tags beginning with \(tag ?? "")"
                case .mention(let mention):
                    "Accounts beginning with \(mention ?? "")"
            }
            
            Text(lookupName).font(.headline)
            
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
        .onTapGesture {
            replaceLast(symbol: "#", replacement: tag)
        }
    }
    
    /// Posting error message
    var postingErrorMessage: some View
    {
        HStack(alignment: .top)
        {
            //
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
        if let replyStatus {
            VStack(alignment: .leading)
            {
                Text("Replying to:").font(.headline)
                StatusPost(replyStatus, showToolBar: false)
                    .padding(.vertical, 10)
                    .background(Color.primary.opacity(0.1))
            }
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
}

// MARK: - previews
#Preview("New status") 
{
    StatusComposer()
}

#Preview("Replying")
{
    StatusComposer(replyStatus: .preview)
}
