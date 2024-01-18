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
    var body: some View 
    {
        RootTabView()
    }
}


#Preview {
    RootView()
}
