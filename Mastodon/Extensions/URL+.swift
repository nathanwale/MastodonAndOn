//
//  URL+.swift
//  Mastodon
//
//  Created by Nathan Wale on 27/2/2024.
//

import Foundation

extension URL
{
    enum InternalQuery
    {
        case viewTag(String)
        case viewUser(String)
    }
    
    enum InternalQueryItemName: String
    {
        case viewTag = "tag"
        case viewUser = "user"
    }
    
    enum InternalHost: String
    {
        case viewTag = "view-tag"
        case viewUser = "view-user"
    }
    
    /// The scheme used for internal URLs
    static let internalScheme = "mastodonandon"
    
    /// Return an internal URL. eg.: http://mastodonandon/view-tag?tag=cats
    /// - host: The host part of the URL. "view-tag" in the example
    /// - query: A dictionary of query terms to values. ["tag": "cats"] in the example
    static func internalUrl(query: InternalQuery) -> Self
    {
        var components = URLComponents()
        
        // assign scheme
        components.scheme = internalScheme
        
        let host: InternalHost
        let queryItem: URLQueryItem
        
        // assign host and queryItem
        switch query {
            case .viewTag(let tagName):
                host = .viewTag
                queryItem = .init(name: InternalQueryItemName.viewTag.rawValue, value: tagName)
            case .viewUser(let userName):
                host = .viewUser
                queryItem = .init(name: InternalQueryItemName.viewTag.rawValue, value: userName)
        }
        
        components.host = host.rawValue
        components.queryItems = [queryItem]
        
        return components.url!
    }
    
    /// Internal URL for viewing posts for a tag
    /// - name: tag name for posts
    static func viewTag(name tagName: String) -> Self
    {
        internalUrl(query: .viewTag(tagName))
    }
    
    /// Internal URL for viewing a user profile
    /// - user: User ID
    static func viewUser(name userName: String) -> Self
    {
        internalUrl(query: .viewUser(userName))
    }
    
    /// Parse an internal URL to return an `InternalQuery`
    /// returns `nil` if unable to parse, or URL scheme isn't internal
    /// - url: URL to pass
    static func internalQueryForUrl(_ url: URL) -> Self.InternalQuery?
    {
        // Is this an internal URL?
        guard url.scheme == internalScheme else {
            return nil
        }
        
        // Can we convert into URLComponents?
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL: \(url.absoluteString)")
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
                if let tagName = getQueryItem(.viewTag) {
                    return .viewTag(tagName)
                }
                
            // It's a view user URL
            case InternalHost.viewUser.rawValue:
                if let userName = getQueryItem(.viewUser) {
                    return .viewUser(userName)
                }
                
            // We don't know what it is, return `nil`
            default:
                return nil
        }
        
        // Something's failed, return `nil`
        return nil
    }
}
