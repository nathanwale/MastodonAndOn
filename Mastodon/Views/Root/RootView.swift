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
        }
        .navigationDestination(for: Route.self)
        {
            route in
            let _ = print("Switching to \(route)")
            switch route {
                case .status(let status):
                    StatusDetail(status: status)
                case .userProfile(let username, let instance):
                    let request = AccountLookupRequest(username: username, instance: instance)
                    UserProfileRequestView(userRequest: request)
                case .postsForTag(tag: let tag):
                    let request = HashtagTimelineRequest(host: MastodonInstance.defaultHost, tag: tag)
                    let source = StatusSource(statuses: [], request: request)
                    StatusList(source: source)
            }
        }
    }
}


#Preview {
    RootView()
        .environmentObject(AppNavigation())
}
