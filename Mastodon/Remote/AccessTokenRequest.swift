//
//  AccessTokenRequest.swift
//  Mastodon
//
//  Created by Nathan Wale on 3/1/2024.
//

import Foundation

struct AccessTokenRequest: ApiRequest
{
    struct Response: Codable
    {
        let accessToken: AccessToken
    }
    
    var host: String
    var authCode: String
    var redirectUri: URL
    
    // method must be POST
    let method: HttpMethod = .post
    
    let endpoint = Endpoint.accessTokenRequest
    let grantType = "authorization_code"
    let scope = "read+write+follow+push" // pluses required for URL Query string
    
    var queryItems: [URLQueryItem] {
        [
            .init(name: "grant_type", value: grantType),
            .init(name: "code", value: authCode),
            .init(name: "client_id", value: Keys.clientKey),
            .init(name: "client_secret", value: Keys.clientSecret),
            .init(name: "redirect_uri", value: redirectUri.absoluteString),
            .init(name: "scope", value: scope)
        ]
    }
    
    func fetchAccessToken() async throws -> AccessToken
    {
        let response = try await send()
        return response.accessToken
    }
}
