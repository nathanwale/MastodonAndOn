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
            VStack(alignment: .leading)
            {
                rebloggedBy
                profileStack
                content
            }.padding(.horizontal)
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
                Text(account.displayName)
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
        HtmlView(html: post.content)
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
#Preview
{
    ScrollView
    {
        VStack
        {
            ForEach(MastodonStatus.previews[0...5])
            {
                preview in
                StatusPost(preview)
            }
        }.padding(10)
    }
}
