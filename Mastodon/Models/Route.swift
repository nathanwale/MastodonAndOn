//
//  Route.swift
//  Mastodon
//
//  Created by Nathan Wale on 4/3/2024.
//

import Foundation

///
/// Represents internal navigation
///
enum Route
{
    /// View posts by tag
    case postsForTag(tag: String)
    
    /// View user by their username
    case userProfile(username: String, instance: String)
 
    /// View a status by ID
    case status(id: MastodonStatus.Identifier)
}
