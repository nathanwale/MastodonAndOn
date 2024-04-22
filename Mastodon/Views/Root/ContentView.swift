//
//  ContentView.swift
//  Mastodon
//
//  Created by Nathan Wale on 7/9/2023.
//

import SwiftUI

struct ContentView: View 
{
    enum LoginState
    {
        case loggedIn
        case loggingOut
        case waitingForLogin
    }
    
    /// Is login complete
    @State var state: LoginState = .waitingForLogin
    
    /// Main view
    var body: some View
    {
        switch state {
            case .loggedIn:
                rootView
            case .loggingOut:
                revokingAccessView
            case .waitingForLogin:
                loginView
        }
    }
    
    /// Login view
    var loginView: some View
    {
        LoginSequenceView() 
        {
            print("Log in complete")
            state = .loggedIn
        }
    }
    
    /// Root View
    var rootView: some View
    {
        RootView() {
            state = .loggingOut
        }
        .environmentObject(AppNavigation())
    }
    
    /// Revoking access view
    var revokingAccessView: some View
    {
        RevokeAccessView(
            host: Config.shared.activeInstanceHost,
            accessToken: Config.shared.accessToken)
        {
            state = .waitingForLogin
        }
    }
}


// MARK: - previews
#Preview("Logged out")
{
    ContentView()
}

#Preview("Logged in")
{
    ContentView(state: .loggedIn)
}
