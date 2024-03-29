//
//  AccountLookupRequest.swift
//  Mastodon
//
//  Created by Nathan Wale on 1/3/2024.
//

import Foundation

///
/// Look up a Mastodon Account  given a username and an instance
///
struct AccountLookupRequest: AccountRequest
{    
    /// The username to look up
    let username: String
    
    /// The Instance the user belongs to
    let instance: String
    
    /// Endpoint for API request
    var endpoint: Endpoint = .accountLookup
    
    // Host and instance are the same here
    var host: String {
        instance
    }
    
    /// Username is sent in the query string
    var queryItems: [URLQueryItem] {
        [.init(name: "acct", value: username)]
    }
    
    /// Init with username and instance
    ///  - username: The username to look up
    ///  - instance: The instance the user belongs to
    init(username: String, instance: String)
    {
        self.username = username
        self.instance = instance
    }
}
