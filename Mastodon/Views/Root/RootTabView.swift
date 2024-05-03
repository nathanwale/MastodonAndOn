//
//  RootTabView.swift
//  Mastodon
//
//  Created by Nathan Wale on 16/1/2024.
//

import SwiftUI

///
/// Root tab view
///
struct RootTabView: View
{
    /// Instance host
    let instanceHost = Config.shared.activeInstanceHost
    
    /// Access token
    let accessToken = Config.shared.accessToken
    
    /// Active user
    let activeAccountId: MastodonAccountId
    
    /// Selected tab, home timeline by default
    @State var selectedTab = Tab.homeTimeline
    
    /// Logout callback
    let logout: () -> ()
    
    /// Represents each tab
    enum Tab: CaseIterable, Identifiable
    {
        case homeTimeline
        case notifications
        case publicTimeline
        case userProfile
        
        /// Title for Tab type
        var title: String
        {
            switch self 
            {
                case .homeTimeline:
                    "Timeline"
                case .notifications:
                    "Notifications"
                case .publicTimeline:
                    "Public"
                case .userProfile:
                    "Profile"
            }
        }
        
        /// ID for Tab type
        var id: String
        {
            self.title
        }
        
        /// Icon for tab type
        var icon: Icon
        {
            switch self {
                case .homeTimeline:
                    Icon.timeline
                case .notifications:
                    Icon.notification
                case .publicTimeline:
                    Icon.public
                case .userProfile:
                    Icon.user
            }
        }
        
        /// Toolbar visibility
        var toolbarVisibility: Visibility
        {
            switch self {
                case .userProfile:
                    .hidden
                default:
                    .visible
            }
        }
    }
    
    // MARK: - subviews
    // body
    var body: some View
    {
        TabView(selection: $selectedTab)
        {
            ForEach(Tab.allCases)
            {
                tab in
                viewFor(tab: tab)
                    .tabItem {
                        Label(
                            tab.title,
                            systemImage: tab.icon.rawValue)
                    }
                    .tag(tab)
                    .toolbar(selectedTab.toolbarVisibility, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
    
    /// Logged in user's timeline
    var homeTimeline: some View
    {
        // timeline request
        let request = HomeTimelineRequest(host: instanceHost, accessToken: accessToken)
        
        // status list with request
        return StatusListRequestView(request: request)
    }
    
    /// Logged in user's notifications
    var notificationsView: some View
    {
        NotificationListView(
            accessToken: accessToken,
            host: instanceHost
        )
        .padding()
    }
    
    /// Logged in user's profile
    var userProfile: some View
    {
        let request = AccountRequestByIdentifier(identifier: activeAccountId, host: instanceHost)
        return UserProfileRequestView(userRequest: request, logout: logout)
    }
    
    /// Public timeline
    var publicTimeline: some View
    {
        // timeline status source
        let request = PublicTimelineRequest(host: instanceHost, accessToken: accessToken)
        return StatusListRequestView(request: request)
    }
    
    /// Select view for a Tab type
    @ViewBuilder
    func viewFor(tab: Tab) -> some View
    {
        switch tab {
            case .homeTimeline:
                homeTimeline
            case .notifications:
                notificationsView
            case .publicTimeline:
                publicTimeline
            case .userProfile:
                userProfile
        }
    }
}


// MARK: - previews
#Preview {
    RootTabView(activeAccountId: MastodonAccount.sampleIdentifier) {
        print("Logged out")
    }
}
