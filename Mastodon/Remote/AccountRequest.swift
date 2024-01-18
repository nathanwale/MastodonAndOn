//
//  AccountRequest.swift
//  Mastodon
//
//  Created by Nathan Wale on 16/1/2024.
//

import Foundation

///
/// Request a Mastodon Account entity for a given identifier and host
/// - identifier: ID of Mastodon account
/// - host: Host of the server to request account from
///
struct AccountRequest: ApiRequest
{
    typealias Response = MastodonAccount
    
    /// Mastodon account ID
    let identifier: MastodonAccountId
    
    /// Host of Mastodon Instance
    let host: String
    
    /// API endpoint
    var endpoint: Endpoint {
        .account(id: identifier)
    }
}
