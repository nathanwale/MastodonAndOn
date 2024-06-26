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
    /// Instance host
    let instanceHost = Config.shared.activeInstanceHost
    
    /// Active account
    let activeAccountId = Config.shared.activeAccountIdentifier
    
    /// App navigation
    @EnvironmentObject var navigation: AppNavigation
    
    /// Are we showing compose sheet?
    @State var showingComposeSheet = false
    
    /// Text of new post
    @State var newPostText = ""
    
    /// Logout callback
    let logout: () -> ()
    
    /// Main view
    var body: some View
    {
        NavigationStack(path: $navigation.path)
        {
            RootTabView(activeAccountId: activeAccountId!, logout: logout)
                // handle navigation changes
                .navigationDestination(for: Route.self)
                {
                    route in
                    routeWasPushed(route: route)
                        .environmentObject(navigation)
                }
                // toolbar
                .toolbar {
                    // compose post button
                    ToolbarItem(placement: .primaryAction)
                    {
                        Button {
                            showingComposeSheet.toggle()
                        } label: {
                            Image(systemName: Icon.compose.rawValue)
                        }
                    }
                }
                // compose sheet
                .sheet(isPresented: $showingComposeSheet) {
                    StatusComposer() {
                        showingComposeSheet = false
                    }
                       
                }
                .navigationTitle(instanceHost)
                .navigationBarTitleDisplayMode(.inline)
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
        switch route 
        {
            // show status
            case .viewStatus(let status):
                StatusDetail(status: status)
                
            // edit status
            case .editStatus(let status):
                StatusComposer(editing: status)
                
            // show user profile
            case .userProfile(let username, let instance):
                let request = AccountLookupRequest(username: username, instance: instance)
                UserProfileRequestView(userRequest: request, logout: logout)
                    .navigationTitle("@\(username)")
                
            // show posts for tag
            case .postsForTag(tag: let tag):
                let request = HashtagTimelineRequest(host: instanceHost, tag: tag)
                StatusListRequestView(request: request)
                    .navigationTitle("#\(tag)")
                
            // reply to status
            case .replyToStatus(let status):
                StatusComposer(replyingTo: status)
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
    RootView() {
        print("logged out")
    }
    .environmentObject(AppNavigation())
}
