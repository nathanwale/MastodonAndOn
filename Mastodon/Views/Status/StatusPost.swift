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
    /// Type for emoji table
    typealias EmojiUrlTable = CustomEmojiText.EmojiUrlTable
    
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
    var emojis: EmojiUrlTable {
        let allEmojis = post.emojis + account.emojis
        return allEmojis.reduce(into: EmojiUrlTable()) {
            dict, emoji in
            if let shortcode = emoji.shortcode {
                dict[shortcode] = emoji.staticUrl
            }
        }
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
            // Post content
            VStack(alignment: .leading)
            {
                rebloggedBy
                profileStack
                content
                    .padding(.bottom)
            }
            .padding(.horizontal)
            
            // Attachments
            mediaAttachments
            StatusToolBar(status: status)
        }
        .padding(0)
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
                CustomEmojiText(account.displayName, emojiUrls: emojis)
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
        StatusContent(post.content)
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
            }
            .padding(0)
            .foregroundColor(.secondary)
        }
    }
    
    /// Media attachments
    var mediaAttachments: some View
    {
        VStack
        {
            ForEach(post.mediaAttachments)
            {
                attachment in
                MediaAttachmentView(attachment: attachment)
            }
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
    }
    .listStyle(.plain)
}
