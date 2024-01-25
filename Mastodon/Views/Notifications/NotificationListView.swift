//
//  NotificationListView.swift
//  Mastodon
//
//  Created by Nathan Wale on 22/1/2024.
//

import SwiftUI

///
/// List of NotificationViews
/// - accessToken: Access token to use during request. Will determine which account's notifications are shown
/// - host: Instance server host
/// - notifications: If specified, will bypass loading Notifications from remote server
///
struct NotificationListView: View
{
    /// Access token to use during request. Will determine which account's notifications are shown
    let accessToken: AccessToken
    
    /// Instance server host
    let host: String
    
    /// Notifications
    @State var notifications: [MastodonNotification]? = nil
    
    /// Body view
    var body: some View
    {
        if let notifications {
            if notifications.isEmpty {
                noNotifications
            } else {
                list
            }
        } else {
            placeholder.task { await loadNotifications() }
        }
    }
    
    /// Placeholder to display while loading notifications from server
    var placeholder: some View
    {
        Text("...")
    }
    
    /// Message to display when there are no notifications
    var noNotifications: some View
    {
        Text("Currently no notifications")
            .italic()
    }
    
    /// List of notifications
    var list: some View
    {
        VStack(alignment: .leading)
        {
            ForEach(notifications ?? [])
            {
                notification in
                NotificationView(notification: notification)
                Divider()
                    .padding(.top)
            }
        }
    }
    
    /// Load notifications from server
    func loadNotifications() async
    {
        do {
            let request = NotificationsRequest(host: host, accessToken: accessToken)
            notifications = try await request.send()
        } catch {
            print(error)
        }
    }
}

            

// MARK: - previews

struct Preview_NotificationList: View
{
    let accessToken: AccessToken?
    let notifications: [MastodonNotification]?

    var body: some View
    {
        ScrollView
        {
            NotificationListView(
                accessToken: accessToken ?? "--none",
                host: MastodonInstance.defaultHost,
                notifications: notifications)
            .padding()
        }
    }
}

#Preview("Static preview notifications")
{
    Preview_NotificationList(
        accessToken: nil,
        notifications: MastodonNotification.samples)
}

#Preview("Live notifications")
{
    Preview_NotificationList(
        accessToken: Secrets.previewAccessToken,
        notifications: nil)
}

#Preview("No notifications")
{
    Preview_NotificationList(
        accessToken: nil,
        notifications: [])
}
