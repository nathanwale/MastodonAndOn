//
//  StatusContextRequest.swift
//  Mastodon
//
//  Created by Nathan Wale on 13/2/2024.
//

import Foundation

///
/// Request for context (ancestors and replies) related to a Status
/// Response type is MastodonStatus.Context
///  - host: Host of Instance server
///  - statusIdentifier: ID of Status to fetch Context for
///  - accessToken: OAuth access token for authorisation
///
struct StatusContextRequest: ApiRequest
{
    /// Returns a list of notifications
    typealias Response = MastodonStatus.Context
    
    /// Endpoint for API request
    var endpoint: Endpoint {
        .statusContext(id: statusIdentifier)
    }

    /// Instance server host
    let host: String
    
    /// ID of Status to fetch context for
    let statusIdentifier: MastodonStatus.Identifier
    
    /// Init with host and access token
    init(host: String, statusIdentifier: MastodonStatus.Identifier)
    {
        self.host = host
        self.statusIdentifier = statusIdentifier
    }
}
