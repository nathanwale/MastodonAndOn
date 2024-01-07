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
    
    var asString: String
    {
        switch self {
            case .none: ""
            case .instance: "/api/v2/instance"
            case .publicTimeline: "/api/v1/timelines/public"
            case .homeTimeline: "/api/v1/timelines/home"
            case .userTimeline(let id): "/api/v1/accounts/\(id)/statuses"
            case .accessTokenRequest: "/oauth/token"
        }
    }
}
