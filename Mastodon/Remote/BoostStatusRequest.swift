//
//  FavouriteStatusRequest.swift
//  Mastodon
//
//  Created by Nathan Wale on 13/3/2024.
//

import Foundation

///
/// Boost a Status by ID
///
struct BoostStatusRequest: ApiRequest
{
    /// Returns a MastodonStatus
    typealias Response = MastodonStatus
    
    /// Host to send request to
    let host: String
    
    /// ID of Status
    let statusId: MastodonStatus.Identifier
    
    /// Method must be Post
    let method: HttpMethod = .post
    
    /// Endpoint
    let endpoint: Endpoint
    
    /// Access token that authorises action
    let accessToken: AccessToken?
    
    /// Init with host, endpoint, accessToken and optional undo
    init(host: String, statusId: MastodonStatus.Identifier, undo: Bool = false, accessToken: AccessToken)
    {
        self.accessToken = accessToken
        self.host = host
        self.statusId = statusId
        if undo {
            self.endpoint = .unboostStatus(id: statusId)
        } else {
            self.endpoint = .boostStatus(id: statusId)
        }
    }
}
