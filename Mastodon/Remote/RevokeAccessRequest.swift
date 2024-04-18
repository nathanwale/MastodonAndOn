//
//  NewStatusRequest.swift
//  Mastodon
//
//  Created by Nathan Wale on 2/4/2024.
//

import Foundation

struct RevokeAccessRequest: ApiRequest
{
    /// Data type of Post
    struct PostData: Codable
    {
        let clientId: String
        let clientSecret: String
        let token: AccessToken
    }
    
    struct Empty {}
    
    /// Returns nothing
    typealias Response = Empty
    
    /// Host to send request to
    let host: String
    
    /// Method must be Post
    let method: HttpMethod = .post
    
    /// Endpoint
    let endpoint: Endpoint = .revokeAccess
    
    /// Access token that authorises action
    let accessToken: AccessToken?
    
    /// Post data
    var postData: Data?
    {
        let object = PostData(
            clientId: Keys.clientKey,
            clientSecret: Keys.clientSecret,
            token: accessToken ?? "<<No access token>>")
        
        do {
            return try JsonLoader.encoder.encode(object)
        } catch {
            print(error)
            return nil
        }
    }
}
