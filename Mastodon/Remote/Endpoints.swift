//
//  Endpoints.swift
//  Mastodon
//
//  Created by Nathan Wale on 3/1/2024.
//

import Foundation

enum Endpoint
{
    case none
    case instance
    case publicTimeline
    case homeTimeline
    case accessTokenRequest
    case userTimeline(userId: MastodonAccountId)
    case account(id: MastodonAccountId)
    case notifications
    case statusContext(id: MastodonStatus.Identifier)
    case accountLookup
    case hashtagTimeline(tag: String)
    
    /// Endpoint as path
    var asPath: String
    {
        switch self {
            case .none: ""
            case .instance: "/api/v2/instance"
            case .publicTimeline: "/api/v1/timelines/public"
            case .homeTimeline: "/api/v1/timelines/home"
            case .userTimeline(let id): "/api/v1/accounts/\(id)/statuses"
            case .accessTokenRequest: "/oauth/token"
            case .account(let id): "/api/v1/accounts/\(id)"
            case .notifications: "/api/v1/notifications"
            case .statusContext(let id): "/api/v1/statuses/\(id)/context"
            case .accountLookup: "/api/v1/accounts/lookup"
            case .hashtagTimeline(let tag): "/api/v1/timelines/tag/\(tag)"
        }
    }
}
