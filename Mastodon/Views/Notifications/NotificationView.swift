//
//  NotificationView.swift
//  Mastodon
//
//  Created by Nathan Wale on 23/1/2024.
//

import SwiftUI

///
/// View for a single notification
/// Varies based on notification type
/// - notification: the `MastodonNotification` to display
///
struct NotificationView: View
{
    /// `MastodonNotification` to display
    let notification: MastodonNotification
    
    /// Account mentioned in notification
    var account: MastodonAccount {
        notification.account
    }
    
    /// Account name
    var accountName: String {
        account.displayName
    }
    
    /// Status referred to in notification
    var status: MastodonStatus? {
        notification.status
    }
    
    /// Description of notification
    var description: String {
        switch notification.type {
            case .mention:
                "**\(accountName)** mentioned you in a post:"
            case .status:
                "**\(accountName)** has posted!"
            case .reblog:
                "**\(accountName)** boosted your post:"
            case .follow:
                "**\(accountName)** is now following you!"
            case .followRequest:
                "**\(accountName)** is requesting to follow you..."
            case .favourite:
                "**\(accountName)** faved your post:"
            case .poll:
                "A poll you voted in has ended!"
            case .update:
                "**\(accountName)**'s post has been updated:"
        }
    }
    
    /// Description as Attributed string
    // So we can bold usernames
    var attributedDescription: AttributedString
    {
        if let markdown = try? AttributedString(markdown: description) {
            return markdown
        } else {
            return AttributedString(description)
        }
    }
    
    /// Icon for notification
    var iconView: some View
    {
        let icon = switch notification.type
        {
            case .mention:
                Icon.quote
            case .status:
                Icon.personPosted
            case .reblog:
                Icon.reblog
            case .follow:
                Icon.follow
            case .followRequest:
                Icon.followRequest
            case .favourite:
                Icon.favourite
            case .poll:
                Icon.poll
            case .update:
                Icon.updated
        }
        return icon.image.foregroundStyle(iconColor)
    }
    
    /// Icon colour for notificaton
    var iconColor: Color
    {
        switch notification.type {
            case .mention, .status, .update:
                Color.green
            case .reblog, .favourite:
                Color.pink
            case .follow, .followRequest:
                Color.orange
            case .poll:
                Color.blue
        }
    }
    
    /// Main view
    var body: some View
    {
        VStack(alignment: .leading)
        {
            descriptionLineView
                .padding(.bottom)
            viewForNotificationType
        }
    }
    
    /// Description line view
    var descriptionLineView: some View
    {
        HStack(alignment: .top)
        {
            iconView
            Text(attributedDescription)
        }
    }
    
    /// Status post view
    var postView: some View
    {
        VStack
        {
            if let status {
                StatusContent(status.content, emojis: status.emojis)
                    .foregroundStyle(.secondary)
                if shouldDisplayToolbar {
                    StatusToolBar(status: status, style: .subdued)
                }
            }
        }
        .padding(.leading)
    }
    
    /// Should we display a toolbar?
    var shouldDisplayToolbar: Bool
    {
        switch notification.type {
            case .mention: true
            default: false
        }
    }
    
    /// view for Notification type
    @ViewBuilder
    var viewForNotificationType: some View
    {
        switch notification.type {
            case .mention, .favourite, .reblog:
                postView
            case .poll:
                pollView
            default:
                // others just need the description line
                EmptyView()
        }
    }

    
    /// Poll view
    var pollView: some View
    {
        VStack(alignment: .leading)
        {
            if let poll = status?.poll
            {
                PollView(poll: poll, text: status?.content ?? "Poll:", emojis: poll.emojis)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.leading)
    }
}
