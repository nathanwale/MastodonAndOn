//
//  AccountRequest.swift
//  Mastodon
//
//  Created by Nathan Wale on 16/1/2024.
//

import Foundation

protocol AccountRequest: ApiRequest where Response == MastodonAccount {}

///
/// Request a Mastodon Account entity for a given identifier and host
/// - identifier: ID of Mastodon account
/// - host: Host of the server to request account from
///
struct AccountRequestByIdentifier: AccountRequest
{
    /// Mastodon account ID
    let identifier: MastodonAccountId
    
    /// Host of Mastodon Instance
    let host: String
    
    /// API endpoint
    var endpoint: Endpoint {
        .account(id: identifier)
    }
}
