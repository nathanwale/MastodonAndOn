//
//  MastodonAccount.swift
//  Mastodon
//
//  Created by Nathan Wale on 7/9/2023.
//

import Foundation

typealias MastodonAccountId = String
typealias WebfingerAccount = String

// MARK: - Entity
/**
    Represents a Mastodon Account
        - Decoded from API described at: https://docs.joinmastodon.org/entities/Account/
 */
class MastodonAccount: Codable
{
    /// Account ID
    var id: MastodonAccountId!
    
    /// Username minus instance domain and `@`
    /// ..ie: `nwale`, not `@nwale@mastodon.social` or `@nwale`
    var username: String!
    
    /// Webfinger account URI.
    /// username for local users, or username@domain for remote users.
    var acct: WebfingerAccount!
    
    /// External host if available, else nil
    var externalHost: String?
    {
        // If there's no '@' in the account, then we
        // assume the host is internal
        guard acct.contains("@") else {
            return nil
        }
        
        return String(acct.split(separator: "@")[1])
    }
    
    /// Location of profile page
    var url: URL!
    
    /// Alternative location of profile page (not sure, this is undocumented). Optional
    var uri: URL?
    
    /// Display name. Separate from Username
    var displayName: String!
    
    /// Profile's bio or description
    var note: String!
    
    /// Location of avatar image (may be animated)
    var avatar: URL!
    
    /// Location of *non-animated* version of avatar
    var avatarStatic: URL!
    
    /// URL to profile banner image. May be animated.
    var header: URL!
    
    /// Non-animated version of profile banner image
    var headerStatic: URL!
    
    /// Does this account manually approve follow requests?
    var locked: Bool!
    
    /// Any ddditional Metadata that may be attached to an account as name/value pairs
    var fields: [MastodonAccountField]!
    
    /// Any custom emoji to be used when rendering profile
    var emojis: [MastodonCustomEmoji]!
    
    /// Is this a self-identified automated account?
    var bot: Bool!
    
    /// Is this a group account? (I think. Not much info about this)
    var group: Bool!
    
    /// Has the account opted in to discovery features?
    var discoverable: Bool?
    
    /// Has the account opted out of being indexed by search engines?
    var noindex: Bool?
    
    /// New account if profile has moved. Otherwise `nil`
    var moved: MastodonAccount?
    
    /// Has the account been suspended?
    var suspended: Bool?
    
    /// True if the account has been silenced
    ///   When true, should be hidden behind a warning screen
    var limited: Bool?
    
    /// When the account was created
    var createdAt: Date!
    
    /// When the last status was posted
    var lastStatusAt: Date?
    
    /// Number of statuses posted
    var statusesCount: Int!
    
    /// Number of followers
    var followersCount: Int!
    
    /// Number of accounts being followed by this account
    var followingCount: Int!
    
    
    /**
     Additional Metadata that may be attached to an account as name/value pairs
     */
    struct MastodonAccountField: Codable
    {
        var name: String
        var value: String
        var verifiedAt: Date?
    }
}
