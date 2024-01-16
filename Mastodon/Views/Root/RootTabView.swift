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
    @State var selectedTab = Tab.homeTimeline
    
    /// Tabs
    enum Tab: CaseIterable, Identifiable
    {
        case homeTimeline
        case notifications
        case publicTimeline
        case userProfile
        
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
        
        var id: String
        {
            self.title
        }
        
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
    }
    
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
            }
        }
    }
        
    var homeTimeline: some View
    {
        // timeline status source
        let source = StatusSource(
            statuses: [],
            request: HomeTimelineRequest.sample)
        
        return StatusList(source: source)
            .environmentObject(AppNavigation())
    }
    
    var notificationsView: some View
    {
        Text("You have no notifications. Sad.")
    }
    
    var userProfile: some View
    {
        Text("User profile")
    }
    
    var publicTimeline: some View
    {
        // timeline status source
        let source = StatusSource(
            statuses: [],
            request: PublicTimelineRequest.sample)
        
        return StatusList(source: source)
            .environmentObject(AppNavigation())
    }
    
    // return a view for a particular tab
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

#Preview {
    RootTabView()
}
