//
//  TimelineRequest.swift
//  Mastodon
//
//  Created by Nathan Wale on 2/11/2023.
//

import Foundation

enum ApiQueryTimeFrame 
{
    case before(MastodonStatus)
    case after(MastodonStatus)
    
    var queryItem: URLQueryItem {
        switch self {
            case .before(let status):
                return .init(name: "since_id", value: status.id)
            case .after(let status):
                return .init(name: "min_id", value: status.id)
        }
    }
}

///
/// An API Request that returns MastodonStatuses
///
protocol MastodonStatusRequest: ApiRequest where Response == [MastodonStatus] 
{
    /// The host of the server. Eg.: "mastodon.social"
    var host: String { get }
    
    /// Time frame for Statuses
    var timeFrame: ApiQueryTimeFrame? { get set }
}

///
/// Defaults for MastodonStatusRequest
/// - limit: The max number of Statuses that will be returned
///
extension MastodonStatusRequest
{
    /// The max number of Statuses that will be returned
    var limit: Int { 20 }
    
    /// query items
    var queryItems: [URLQueryItem]? {
        var items = [
            URLQueryItem(name: "limit", value: String(limit)),
        ]
        
        if let timeFrame {
            items.append(timeFrame.queryItem)
        }
        
        return items
    }
}

///
/// A Public Timeline Request: will return public statuses that have just been posted
///
struct PublicTimelineRequest: MastodonStatusRequest
{
    let host: String
    let endpoint = Endpoint.publicTimeline
    var timeFrame: ApiQueryTimeFrame?
    let accessToken: AccessToken?
}

///
/// A Timeline Request for a particular account
/// - userid: The Mastodon Account ID for the User
///
struct UserTimelineRequest: MastodonStatusRequest
{
    let host: String
    let userid: MastodonAccountId
    var timeFrame: ApiQueryTimeFrame?
    let accessToken: AccessToken?
    
    var endpoint: Endpoint {
        .userTimeline(userId: userid)
    }
}

///
/// A home timeline for a user. Requires access token
///
struct HomeTimelineRequest: MastodonStatusRequest
{
    let host: String
    var timeFrame: ApiQueryTimeFrame?
    let accessToken: AccessToken?
    let endpoint = Endpoint.homeTimeline
}
