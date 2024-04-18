//
//  ContentView.swift
//  Mastodon
//
//  Created by Nathan Wale on 7/9/2023.
//

import SwiftUI

struct ContentView: View 
{
    /// Is login complete
    @State var loginComplete = false
    
    /// Main view
    var body: some View
    {
        if loginComplete {
            rootView
        } else {
            loginView
        }
    }
    
    /// Login view
    var loginView: some View
    {
        LoginSequenceView() {
            print("Log in complete")
            loginComplete = true
        }
    }
    
    /// Root View
    var rootView: some View
    {
        RootView()
    }
}


// MARK: - previews
#Preview
{
    ContentView()
}
