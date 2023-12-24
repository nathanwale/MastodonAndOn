//
//  SignIn.swift
//  Mastodon
//
//  Created by Nathan Wale on 18/12/2023.
//

import Foundation

struct SignIn
{
    /// OAuth Callback scheme to use
    let callbackEndpoint = "auth"
    
    /// URL Endpoint to sign in to
    let endpoint = "/oauth/authorize"
    
    /// URL Scheme to use
    let scheme = "https"

    /// callback scheme
    let callbackScheme = "mastodonandon"
    
    /// Host to sign in to
    let host: String
    
    /// OAuth callback URL
    var callbackUrl: URL?
    {
        // url components object
        var components = URLComponents()
        
        // build base URL
        components.scheme = callbackScheme
        components.host = callbackEndpoint
        
        // return url
        return components.url
    }
    
    /// URL to sign in to
    var signInUrl: URL?
    {
        // url components object
        var components = URLComponents()
        
        // build base URL
        components.scheme = scheme
        components.host = host
        components.path = endpoint
        
        // add query items
        components.queryItems = queryItems
        
        // return url
        return components.url
    }
    
    /// Query items for sign in URL
    var queryItems: [URLQueryItem]
    {
        [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: Keys.clientKey),
            URLQueryItem(name: "redirect_uri", value: callbackUrl?.absoluteString)
        ]
    }
}
