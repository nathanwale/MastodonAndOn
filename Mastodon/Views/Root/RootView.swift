//
//  RootView.swift
//  Mastodon
//
//  Created by Nathan Wale on 16/1/2024.
//

import SwiftUI

///
/// RootView:
///     Handles switching between different timelines, notifications, user settings, etc.
///     Calls log in view when needed
///
struct RootView: View
{
    @EnvironmentObject var navigation: AppNavigation
    
    var body: some View
    {
        NavigationStack(path: $navigation.path)
        {
            RootTabView()
                // handle navigation changes
                .navigationDestination(for: Route.self)
                {
                    route in
                    routeWasPushed(route: route)
                        .environmentObject(navigation)
                }
        }
        // handle internal URLs
        .onOpenURL
        {
            url in 
            internalUrlWasOpened(url: url)
        }
    }
    
    /// Handle navigation changes
    @ViewBuilder
    func routeWasPushed(route: Route) -> some View
    {
        let _ = print("Switching to \(route)")
        switch route {
            case .status(let status):
                StatusDetail(status: status)
            case .userProfile(let username, let instance):
                let request = AccountLookupRequest(username: username, instance: instance)
                UserProfileRequestView(userRequest: request)
            case .postsForTag(tag: let tag):
                let request = HashtagTimelineRequest(host: MastodonInstance.defaultHost, tag: tag)
                StatusListRequestView(request: request)
        }
    }
    
    /// Handle internel url's being opened
    func internalUrlWasOpened(url: URL)
    {
        // ensure url is being handled
        guard let route = url.internalLocator?.route else {
            print("Internal URL is not handled: \(url)")
            return
        }
        
        print("Visiting \(route)")
        navigation.push(route)
    }
}


#Preview {
    RootView()
        .environmentObject(AppNavigation())
}
