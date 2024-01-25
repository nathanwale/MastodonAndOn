//
//  NotificationsRequest.swift
//  Mastodon
//
//  Created by Nathan Wale on 22/1/2024.
//

import Foundation

///
/// Request for list of Notifications.
/// Response type is [MastodonNotification]
///  - host: Host of Instance server
///  - accessToken: OAuth access token for authorisation
///
struct NotificationsRequest: ApiRequest
{
    /// Returns a list of notifications
    typealias Response = [MastodonNotification]
    
    /// Endpoint for API request
    let endpoint: Endpoint = .notifications
    
    /// Auth access token
    let accessToken: AccessToken?
    
    /// Instance server host
    let host: String
    
    /// Init with host and access token
    init(host: String, accessToken: AccessToken)
    {
        self.accessToken = accessToken
        self.host = host
    }
}
