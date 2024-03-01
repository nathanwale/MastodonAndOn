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
struct AccountLookupRequest: ApiRequest
{
    // Returns a MastodonAccount
    typealias Response = MastodonAccount
    
    /// The username to look up
    let username: String
    
    /// The Instance the user belongs to
    let instance: String
    
    /// Endpoint for API request
    var endpoint: Endpoint {
        .accountLookup(username: username)
    }
    
    // Host and instance are the same here
    var host: String {
        instance
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
