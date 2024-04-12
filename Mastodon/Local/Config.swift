//
//  Persistence.swift
//  Mastodon
//
//  Created by Nathan Wale on 5/4/2024.
//

import SwiftUI

protocol ConfigProvider
{
    var activeInstanceHost: String { get set }
    var activeAccountIdentifier: MastodonAccountId? { get set }
    var accessToken: AccessToken { get }
}

struct Config: ConfigProvider
{
    /// String keys
    enum Keys: String
    {
        case activeInstance = "active-instance"
        case accessToken = "access-token"
        case activeAccountIdentifier = "active-account-id"
    }
    
    /// Shared instance
    static var shared: any ConfigProvider = {
        if isPreviewMode {
            return PreviewConfig()
        } else {
            return Self()
        }
    }()
    
    /// Are we running in preview mode?
    static var isPreviewMode: Bool
    {
        if let flag = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] {
            return flag == "1"
        } else {
            return false
        }
    }
    
    /// Active Instance: the instance the user is logged in to
    @AppStorage(Keys.activeInstance.rawValue)
    var activeInstanceHost: String = MastodonInstance.defaultHost
    
    /// Logged in account
    ///
    @AppStorage(Keys.activeAccountIdentifier.rawValue)
    var activeAccountIdentifier: MastodonAccountId?
    
    /// Access token, used for authenticated operations
    var accessToken: AccessToken
    {
        get {
            if let token = try? KeychainToken.accessToken.retrieve() {
                return token
            } else {
                return "<<TOKEN NOT FOUND>>"
            }
        }
    }
}


///
/// Configuration for Previews
///
struct PreviewConfig: ConfigProvider
{
    // Use default instance
    var activeInstanceHost = MastodonInstance.defaultHost
    
    // Use token stored in secrets
    var accessToken = Secrets.previewAccessToken
    
    // Preview account
    var activeAccountIdentifier: MastodonAccountId? = MastodonAccount.sampleIdentifier
}
