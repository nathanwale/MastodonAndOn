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
    /// 
    /// Style of the toolbar
    ///
    enum Style
    {
        /// Prominent style: coloured background
        case prominent
        
        /// Subdued style: translucent background
        case subdued
    }
    
    /// Instance host
    let instanceHost = Config.shared.activeInstanceHost
    
    /// Access token
    let accessToken = Config.shared.accessToken
    
    /// The status this toolbar belongs to
    let status: MastodonStatus
    
    /// The style of this toolbar
    var style = Style.prominent
    
    /// Navigation object
    @EnvironmentObject private var navigation: AppNavigation
    
    /// Has status been reblogged?
    @State var wasReblogged = false
    
    /// Has status been favourited?
    @State var wasFaved = false
    
    /// Reblog count
    @State var reblogCount = 0
    
    /// Fave count
    @State var faveCount = 0
    
    /// Init with Status and optional style
    init(status: MastodonStatus, style: Style = .prominent)
    {
        self.status = status
        self.style = style
        _wasFaved = .init(initialValue: status.favourited ?? false)
        _wasReblogged = .init(initialValue: status.reblogged ?? false)
        _reblogCount = .init(initialValue: status.reblogsCount)
        _faveCount = .init(initialValue: status.favouritesCount)
    }
    
    /// Reblogged icon
    var rebloggedIcon: Icon
    {
        wasReblogged
            ? .reblogFilled
            : .reblog
    }
    
    /// Faved icon
    var favedIcon: Icon
    {
        wasFaved
            ? .favouriteFilled
            : .favourite
    }
    
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
            ("Reblog", rebloggedIcon, reblogStatus, status.reblogsCount),
            ("Favourite", favedIcon, favouriteStatus, status.favouritesCount),
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
        let action: () async -> Void
        
        /// Body view
        var body: some View
        {
            Button(label, systemImage: icon.rawValue) {
                Task {
                    await action()
                }
            }
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
    func showReplies() async
    {
        navigation.push(.status(status))
        print("Showing \(status.repliesCount ?? 0) replies...")
    }
    
    /// Reply to this status
    func replyToStatus()
    {
        print("Replying to status...")
    }
    
    /// Reblog this status
    func reblogStatus() async
    {
        print("Reblogged status is now \(status.reblogged?.description ?? "Unset")")
        
        // Request to boost or undo boost
        let request = BoostStatusRequest(
            host: instanceHost,
            statusId: status.id,
            undo: wasReblogged,
            accessToken: accessToken)
        
        do {
            let returnedStatus = try await request.send()
            wasReblogged = (returnedStatus.reblogged == true)
            reblogCount = returnedStatus.reblogsCount
        } catch {
            print(error)
        }
    }
    
    /// Favourite this status
    func favouriteStatus() async
    {
        print("Favourited status is now \(status.favourited?.description ?? "Unset")")
        
        // Request to boost or undo boost
        let request = FavouriteStatusRequest(
            host: instanceHost,
            statusId: status.id,
            undo: wasFaved,
            accessToken: accessToken)
        
        do {
            let returnedStatus = try await request.send()
            wasFaved = (returnedStatus.favourited == true)
            faveCount = returnedStatus.favouritesCount
        } catch {
            print(error)
        }
    }
    
    /// Share this status
    func shareStatus()
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
