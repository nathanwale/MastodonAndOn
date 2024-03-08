//
//  StatusToolBar.swift
//  Mastodon
//
//  Created by Nathan Wale on 26/9/2023.
//

import SwiftUI

///
/// Allows user interaction with a Status
///
struct StatusToolBar: View
{
    /// Style of the toolbar
    enum Style
    {
        /// Prominent style: coloured background
        case prominent
        
        /// Subdued style: translucent background
        case subdued
    }
    
    /// The status this toolbar belongs to
    let status: MastodonStatus
    
    /// The style of this toolbar
    var style = Style.prominent
    
    /// Navigation object
    @EnvironmentObject private var navigation: AppNavigation
    
    /// Background style
    var background: some View
    {
        switch style
        {
            case .prominent: Color(uiColor: .tertiarySystemFill)
            case .subdued: Color(uiColor: .tertiarySystemFill).opacity(0.25)
        }
    }
    
    /// Body view
    var body: some View
    {
        // Actions that have status counts associated with them
        let actionsWithCounts = [
            ("Show replies", Icon.replies, showReplies, status.repliesCount),
            ("Reblog", Icon.reblog, reblogStatus, status.reblogsCount),
            ("Favourite", Icon.favourite, favouriteStatus, status.favouritesCount),
        ]
        
        // Button stack
        HStack
        {
            // Buttons with counts (comment, boost, fave)
            ForEach(actionsWithCounts, id: \.0)
            {
                (label, icon, action, count) in
                ButtonWithCount(
                    label: label,
                    icon: icon,
                    count: count ?? 0,
                    action: action)
            }
            Spacer()
            Divider()
            // Share button
            Button("Share", systemImage: Icon.share.rawValue, action: shareStatus)
            Divider()
            Spacer()
            // Reply button
            Button("Reply", systemImage: Icon.reply.rawValue, action: replyToStatus)
                .labelStyle(.titleAndIcon)
        }
        .labelStyle(.iconOnly)
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(background)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    /// A button with a count (eg. replies)
    struct ButtonWithCount: View
    {
        /// Button label. May not be shown
        let label: String
        
        /// Icon to display. May not be shount
        let icon: Icon
        
        /// Count to show next to button
        let count: Int
        
        /// Action called on button tap
        let action: () -> Void
        
        /// Body view
        var body: some View
        {
            Button(label, systemImage: icon.rawValue, action: action)
            Text(count.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.leading, -5)
                .padding(.trailing, 10)
        }
    }
}
 

// MARK: - actions
extension StatusToolBar
{
    /// Show replies for this status
    func showReplies()
    {
        navigation.push(.status(status))
        print("Showing \(status.repliesCount ?? 0) replies...")
    }
    
    /// Reply to this status
    func replyToStatus() -> Void
    {
        print("Replying to status...")
    }
    
    /// Reblog this status
    func reblogStatus() -> Void
    {
        print("Reblogging status...")
    }
    
    /// Favourite this status
    func favouriteStatus() -> Void
    {
        print("Favouriting status...")
    }
    
    /// Share this status
    func shareStatus() -> Void
    {
        print("Sharing status...")
    }
}


// MARK: - previews
#Preview("Status tool bar", traits: .fixedLayout(width: 400, height: 50)) 
{
    VStack(spacing: 20)
    {
        Text("Style prominent")
        StatusToolBar(status: MastodonStatus.preview)
        Divider()
        Text("Style subdued")
        StatusToolBar(status: MastodonStatus.preview, style: .subdued)
    }
    .environmentObject(AppNavigation())
    .padding(20)
}
