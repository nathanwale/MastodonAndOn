//
//  Environment+.swift
//  Mastodon
//
//  Created by Nathan Wale on 4/3/2024.
//

import SwiftUI

///
/// Environment Key for Navigation
///
private struct NavigationPathKey: EnvironmentKey
{
    static let defaultValue: [Route] = []
}

///
/// Extending Environment Values to store Navigation
///
extension EnvironmentValues
{
    var navigationPath: [Route]
    {
        get { self[NavigationPathKey.self] }
        set { self[NavigationPathKey.self] = newValue }
    }
}

///
/// Extending View to give easy access to pushing a Route onto the Navigation Path
///
extension View
{
    func pushRoute(_ route: Route)
    {
        @Environment(\.navigationPath) var path
        
    }
}
