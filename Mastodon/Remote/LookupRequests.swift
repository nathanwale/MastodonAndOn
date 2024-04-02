//
//  HashtagLookupRequest.swift
//  Mastodon
//
//  Created by Nathan Wale on 20/3/2024.
//

import Foundation

///
/// What type of look up to perform
///
enum LookupType: String
{
    /// Perform hashtag lookup
    case hashtag = "hashtags"
    
    /// Perform account lookup
    case mention = "accounts"
}

///
/// Results of a lookup
///
enum LookupResult: Identifiable
{
    /// A collection of accounts
    case mention(MastodonAccount)
    
    /// A collection of hashtags
    case hashtag(tag: String, count: Int)

    /// Identifier
    var id: String {
        switch self {
            case .mention(let account):
                account.acct
            case .hashtag(let tag, _):
                tag
        }
    }
}


///
/// A request that returns a options for a search term
///
protocol LookupRequest: ApiRequest
{
    /// Lookup the query and return an array of strings that match
    func lookup() async throws -> [LookupResult]
    
    /// The type of lookup
    var lookupType: LookupType { get }
    
    /// The limit to number of results
    var limit: Int { get }
    
    /// The term to lookup
    var searchTerm: String { get }
}

extension LookupRequest
{
    /// Query string
    var queryItems: [URLQueryItem]
    {
        [
            .init(name: "q", value: searchTerm),
            .init(name: "type", value: lookupType.rawValue),
            .init(name: "resolve", value: "false"),
            .init(name: "limit", value: String(limit)),
            .init(name: "exclude_unreviewed", value: "true")
        ]
    }
    
    /// Default limit is 10
    var limit: Int { 5 }
}

// MARK: - hashtags
///
/// Search for Hashtags based on a search term
///
struct HashtagLookupRequest: LookupRequest
{
    /// Instance to perform search on
    let host: String
    
    /// Search term to look up
    let searchTerm: String
    
    /// Endpoint
    let endpoint: Endpoint = .hashtagLookup
    
    /// Lookup type
    let lookupType: LookupType = .hashtag
    
    /// Auth access token
    let accessToken: AccessToken?

    /// Result type
    struct Response: Codable
    {
        let hashtags: [Tag]
        struct Tag: Codable
        {
            /// Actual name of tag (excludes '#')
            let name: String
            
            /// Usage Statistics
            let history: [History]
            
            /// Count of uses in returned history
            var count: Int {
                history.reduce(0) {
                    $0 + (Int($1.uses) ?? 0)
                }
            }
            
            /// History of usage of this tag
            struct History: Codable
            {
                let uses: String
            }
        }
    }
    
    /// Fetch tag names as String array
    func lookup() async throws -> [LookupResult]
    {
        try await send().hashtags.map {
            LookupResult.hashtag(tag: $0.name, count: $0.count)
        }
    }
}


// MARK: - mentions
///
/// Search for Mention based on a search term
///
struct MentionLookupRequest: LookupRequest
{
    /// Returns a list of Mastodon Accounts
    typealias Response = [MastodonAccount]
    
    /// Instance to perform search on
    let host: String
    
    /// Search term to look up
    let searchTerm: String
    
    /// Endpoint
    let endpoint: Endpoint = .mentionLookup
    
    /// Lookup type
    let lookupType: LookupType = .mention
    
    /// Auth access token
    let accessToken: AccessToken?
        
    /// Fetch tag names as String array
    func lookup() async throws -> [LookupResult]
    {
        try await send().map {
            .mention($0)
        }
    }
}
