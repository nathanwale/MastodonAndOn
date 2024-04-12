//
//  AccountRequest.swift
//  Mastodon
//
//  Created by Nathan Wale on 16/1/2024.
//

import Foundation

///
/// Verify an Access Token, returns a MastodonAccount
///
struct VerifyAccessTokenRequest: ApiRequest
{
    typealias Response = MastodonAccount
    
    /// Host of Mastodon Instance
    let host: String
    
    /// API endpoint
    let endpoint: Endpoint = .verifyAccessToken
    
    /// Access token that authorises action
    let accessToken: AccessToken?
    
    /// Init with host and access token
    init(host: String, accessToken: AccessToken)
    {
        self.host = host
        self.accessToken = accessToken
    }
}
