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
enum Route: Codable, Hashable
{
    /// View posts by tag
    case postsForTag(tag: String)
    
    /// View user by their username
    case userProfile(username: String, instance: String)
 
    /// View a status
    case viewStatus(MastodonStatus)
    
    /// Edit status
    case editStatus(MastodonStatus)
    
    /// Reply to a status
    case replyToStatus(MastodonStatus)
}
