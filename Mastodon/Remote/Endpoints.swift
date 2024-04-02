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
    case favouriteStatus(id: MastodonStatus.Identifier)
    case unfavouriteStatus(id: MastodonStatus.Identifier)
    case boostStatus(id: MastodonStatus.Identifier)
    case unboostStatus(id: MastodonStatus.Identifier)
    case hashtagLookup
    case mentionLookup
    
    /// Endpoint as path
    var asPath: String
    {
        switch self 
        {
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
            case .favouriteStatus(id: let id): "/api/v1/statuses/\(id)/favourite"
            case .unfavouriteStatus(id: let id): "/api/v1/statuses/\(id)/unfavourite"
            case .boostStatus(id: let id): "/api/v1/statuses/\(id)/reblog"
            case .unboostStatus(id: let id): "/api/v1/statuses/\(id)/unreblog"
            case .hashtagLookup: "/api/v2/search"
            case .mentionLookup: "/api/v1/accounts/search"
        }
    }
}
