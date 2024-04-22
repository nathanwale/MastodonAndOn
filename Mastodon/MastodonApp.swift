//
//  MastodonApp.swift
//  Mastodon
//
//  Created by Nathan Wale on 7/9/2023.
//

import SwiftUI

@main
struct MastodonApp: App 
{
    var loginState: ContentView.LoginState
    {
        if Config.shared.haveRequiredUserInfo {
            return .loggedIn
        } else {
            return .loggingOut
        }
    }
    
    var body: some Scene
    {
        WindowGroup 
        {
            let _ = print("""
            ...Starting app!
            Stored user details...
            Active user id: \(Config.shared.activeAccountIdentifier ?? "None"), 
            Active instance: \(Config.shared.activeInstanceHost),
            Access token: \(Config.shared.accessToken)
            """)
            
            ContentView(state: loginState)
        }
    }
}
