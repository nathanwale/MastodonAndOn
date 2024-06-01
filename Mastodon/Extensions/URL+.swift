//
//  URL+.swift
//  Mastodon
//
//  Created by Nathan Wale on 27/2/2024.
//

import Foundation

///
/// Internal URLs
///
extension URL
{
    ///
    /// An Internal Locator for navigation
    ///
    enum InternalLocator
    {
        /// View posts by tag
        case viewTag(String)
        
        /// View user by their username
        case viewUser(username: String, instance: String)
        
        /// Convert to Route enum
        var route: Route {
            switch self {
                case .viewTag(let tag):
                    return .postsForTag(tag: tag)
                case .viewUser(let username, let instance):
                    return .userProfile(username: username, instance: instance)
            }
        }
    }
    
    /// Internal query names
    private enum InternalQueryItemName: String
    {
        case tag = "tag"
        case username = "username"
        case instance = "instance"
    }
    
    /// Internal URL hosts
    private enum InternalHost: String
    {
        case viewTag = "view-tag"
        case viewUser = "view-user"
    }
    
    /// The scheme used for internal URLs
    static let internalScheme = "mastodonandon"
    
    /// Return an internal URL. eg.: mastodonandon://view-tag?tag=cats
    /// - host: The host part of the URL. "view-tag" in the example
    /// - query: A dictionary of query terms to values. ["tag": "cats"] in the example
    static func internalUrl(locator: InternalLocator) -> Self
    {
        var components = URLComponents()
        
        // assign scheme
        components.scheme = internalScheme
        
        let host: InternalHost
        let queryItemDict: [InternalQueryItemName: String]
        
        // assign host and queryItem
        switch locator {
            case .viewTag(let tagName):
                host = .viewTag
                queryItemDict = [.tag: tagName]
            case .viewUser(let username, let instance):
                host = .viewUser
                queryItemDict = [
                    .username: username,
                    .instance: instance
                ]
        }
        
        components.host = host.rawValue
        
        // map queryItemDict to an array of URLQueryItem
        components.queryItems = queryItemDict.map {
            key, value in
            .init(name: key.rawValue, value: value)
        }
        
        return components.url!
    }
    
    /// Internal URL for viewing posts for a tag
    /// - name: tag name for posts
    static func viewTag(name tagName: String) -> Self
    {
        internalUrl(locator: .viewTag(tagName))
    }
    
    /// Internal URL for viewing a user profile
    /// - user: User ID
    static func viewUser(name username: String, instance: String) -> Self
    {
        internalUrl(locator: .viewUser(username: username, instance: instance))
    }
    
    /// Parse an internal URL to return an `InternalQuery`
    /// returns `nil` if unable to parse, or URL scheme isn't internal
    var internalLocator: Self.InternalLocator?
    {
        // Is this an internal URL?
        guard scheme == Self.internalScheme else {
            return nil
        }
        
        // Can we convert into URLComponents?
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            print("Invalid URL: \(absoluteString)")
            return nil
        }
        
        func getQueryItem(_ name: InternalQueryItemName) -> String?
        {
            
            components.queryItems?.first(where: {$0.name == name.rawValue})?.value
        }
        
        // Interpret URL components
        switch components.host 
        {
            // It's a view tag URL
            case InternalHost.viewTag.rawValue:
                if let tagName = getQueryItem(.tag)
                {
                    return .viewTag(tagName)
                }
                
            // It's a view user URL
            case InternalHost.viewUser.rawValue:
                if let username = getQueryItem(.username),
                   let instance = getQueryItem(.instance)
                {
                    return .viewUser(username: username, instance: instance)
                }
                
            // We don't know what it is, return `nil`
            default:
                return nil
        }
        
        // Something's failed, return `nil`
        return nil
    }
}
