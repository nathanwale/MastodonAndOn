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
    
    /// Content should be hidden if it's marked `sensitive=true` and user hasn't chosen to reveal it
    var shouldHideContent: Bool {
        post.sensitive && !hasRevealedSensitiveContent
    }
    
    
    // Init
    init(_ status: MastodonStatus)
    {
        self.status = status
    }
    
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
            
            // Toolbar
            StatusToolBar(status: status)
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
    }
    
    /// Profile features
    var profileStack: some View
    {
        HStack(alignment: .bottom)
        {
            profileImage
            VStack(alignment: .leading)
            {
                // Display name
                CustomEmojiText(account.displayName, emojis: emojis)
                    .font(.headline)
                    .lineLimit(1)
                HStack
                {
                    // Webfinger account uri: eg. "@username@instance.org"
                    Text("@" + account.acct)
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
