//
//  StatusView.swift
//  Mastodon
//
//  Created by Nathan Wale on 19/9/2023.
//

import SwiftUI

///
/// Represents a single Mastodon Status
/// - status: The Status to be displayed
///
struct StatusPost: View
{
    /// The Status for this view
    var status: MastodonStatus
    
    /// Show toolbar if true
    var showToolBar = true
    
    /// Post to be displayed.
    /// Reblogged Status if it exists, else the original Status
    var post: MastodonStatus {
        status.reblog ?? status
    }
    
    /// Main account to be displayed
    /// Reblogged account, if reblogged. Else author of original status
    var account: MastodonAccount {
        status.reblog?.account ?? status.account
    }
    
    /// Custom emojis for this post
    var emojis: [MastodonCustomEmoji] {
        post.emojis + account.emojis
    }
    
    /// User has chosen to reveal sensitive content
    @State var hasRevealedSensitiveContent = false
    
    /// Navigation object
    @EnvironmentObject private var navigation: AppNavigation
    
    /// Content should be hidden if it's marked `sensitive=true` and user hasn't chosen to reveal it
    var shouldHideContent: Bool {
        post.sensitive && !hasRevealedSensitiveContent
    }
    
    /// Can the user edit this post?
    var isEditable: Bool 
    {
        // If active ID or post ID are nil, we can't edit
        guard
            let activeId = Config.shared.activeAccountIdentifier,
            let postId = post.account.id
        else {
            return false
        }
        
        // Does this post belong to the active user?
        return activeId == postId
    }
    
    // User Profile Nav Route
    var userProfileRoute: Route
    {
        // Instance is external host or the active instance
        let instance = account.externalHost ??
            Config.shared.activeInstanceHost
        
        return .userProfile(
            username: account.username,
            instance: instance)
    }
    
    // Init
    init(_ status: MastodonStatus, showToolBar: Bool = true)
    {
        self.status = status
        self.showToolBar = showToolBar
    }
    
    /// Edit reply
    func editReply()
    {
        print("Editing Status #\(post.id ?? "?")")
        navigation.push(.editStatus(post))
    }
    
    /// Visit this user
    func visitProfile()
    {
        print("Visiting", userProfileRoute)
        navigation.push(userProfileRoute)
    }
    
    /// Visit status detail
    func visitStatusDetail()
    {
        navigation.push(.viewStatus(status))
    }
    
    // MARK: - subviews
    // Body
    var body: some View
    {
        VStack(alignment: .leading)
        {
            // Profile
            VStack
            {
                rebloggedBy
                profileStack
            }
            .padding([.leading, .trailing])
            
                        
            // Post content or content warning
            if shouldHideContent {
                contentWarning
            } else {
                // Show re-hide
                if hasRevealedSensitiveContent {
                    hideSensitiveContentButton
                }
                postContent
            }
            
            // Toolbar, should pass in `post`, because the actions on
            // the toolbar will apply to the reblogged content if it exists
            if showToolBar {
                StatusToolBar(status: post)
            }
        }
        .padding(0)
    }
    
    /// Post content
    var postContent: some View
    {
        VStack
        {
            VStack(alignment: .leading)
            {
                content
                    .padding(.bottom)
                    .onTapGesture {
                        visitStatusDetail()
                    }
            }
            .padding(.horizontal)
            
            // Attachments
            MultipleMediaAttachment(attachments: post.mediaAttachments)
            
            // Preview card if available
            if let card = post.card {
                PreviewCardView(card: card)
                    .padding()
            }
        }
    }
    
    /// Content warning
    var contentWarning: some View
    {
        HStack(alignment: .top)
        {
            Icon.contentWarning.image.font(.system(size: 60))
            VStack(alignment: .leading)
            {
                Text("Content warning. Tap to reveal")
                    .textCase(.uppercase)
                    .font(.caption2)
                Text(post.spoilerText)
                    .fixedSize(horizontal: false, vertical: true) // ensures text wraps
            }
            Spacer()
        }
        .padding()
        .background(.primary.opacity(0.2))
        .onTapGesture {
            hasRevealedSensitiveContent = true
        }
    }
    
    /// Hide sensitive content button
    var hideSensitiveContentButton: some View
    {
        HStack
        {
            Spacer()
            Icon.contentWarning.image
            Text("Hide sensitive content")
            Icon.chevronDown.image
            Spacer()
        }
        .padding(5)
        .background(.primary.opacity(0.2))
        .onTapGesture {
            hasRevealedSensitiveContent = false
        }
    }
    
    /// Profile image
    var profileImage: some View
    {
        ProfileImage(url: account.avatar)
            .onTapGesture {
                visitProfile()
            }
    }
    
    /// Profile features
    var profileStack: some View
    {
        HStack(alignment: .bottom)
        {
            profileImage
            VStack(alignment: .leading)
            {
                HStack
                {
                    // Display name
                    CustomEmojiText(account.displayName, emojis: emojis)
                        .font(.headline)
                        .lineLimit(1)
                        .onTapGesture {
                            visitProfile()
                        }
                    
                    // Show edit button if editable
                    if isEditable {
                        Spacer()
                        editButton
                    }
                }
                HStack
                {
                    // Webfinger account uri: eg. "@username@instance.org"
                    Text("@" + account.acct)
                        .onTapGesture {
                            visitProfile()
                        }
                    // Space
                    Spacer()
                    // When created. eg. "3 days ago"
                    Text(post.createdAt.relativeFormatted)
                }
                .font(.caption)
            }
        }
    }
    
    /// Content of post
    var content: some View
    {
        StatusContent(post.content, emojis: emojis)
    }
    
    /// Reblogged by, if reblog exists
    @ViewBuilder
    var rebloggedBy: some View
    {
        if status.reblog != nil {
            HStack
            {
                Icon.reblog.image
                Text("reblogged by \(status.account.displayName)")
                    .font(.caption)
                Spacer()
            }
            .foregroundColor(.secondary)
        }
    }
    
    /// Edit button
    var editButton: some View
    {
        Button("Edit", systemImage: Icon.compose.rawValue, action: editReply)
            .labelStyle(.titleAndIcon)
    }
}


// MARK: - previews
#Preview("With samples")
{
    List(MastodonStatus.previews)
    {
        status in
        StatusPost(status)
            .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0))
            .listRowSeparator(.hidden)
            .environmentObject(AppNavigation())
    }
    .listStyle(.plain)
}
