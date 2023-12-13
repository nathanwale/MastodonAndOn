//
//  MastodonInstanceConfiguration.swift
//  Mastodon
//
//  Created by Nathan Wale on 1/11/2023.
//

import Foundation

///
/// Configuration of an Instance
///
struct MastodonInstanceConfiguration: Codable
{
    /// URLs of interest for client apps
    let urls: Urls
    
    /// Limits relating to accounts
    let accounts: AccountPolicy
    
    /// Limits relating to authoring Statuses
    let statuses: StatusPolicy
    
    /// Hints and limits for which Media Attachments an instance will accept
    let mediaAttachments: MediaAttachmentPolicy
    
    /// Limits relating to Polls on an Instance
    let polls: PollPolicy
    
    /// Policy related to translation for an Instance
    let translation: TranslationPolicy
}


// MARK: - inner types
extension MastodonInstanceConfiguration
{
    /// URLs of interest for client apps
    struct Urls: Codable
    {
        /// Status. Not described in docs. Optional? Who knows.
        let status: URL?
        
        /// Websockets url for connecting to the streaming API. Optional
        let streaming: URL?
        
        /// Alias for `streaming` as described in docs. Optional
        let streamingApi: URL?
        
        /// Coding keys
        enum CodingKeys: String, CodingKey
        {
            case status
            case streaming
            case streamingApi
        }
        
        // We have to manually decode, because URLs are sometimes empty strings
        init(from decoder: Decoder) throws 
        {
            // value container
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // decode
            self.status = try? container.decodeIfPresent(URL.self, forKey: .status)
            self.streaming = try? container.decodeIfPresent(URL.self, forKey: .streaming)
            self.streamingApi = try? container.decodeIfPresent(URL.self, forKey: .streamingApi)
        }
    }
    
    /// Limits relating to accounts
    struct AccountPolicy: Codable
    {
        /// The maximum number of featured tags allowed for each account.
        let maxFeaturedTags: Int
    }
    
    /// Limits relating to authoring Statuses
    struct StatusPolicy: Codable
    {
        /// Maximum allowed characters per Status
        let maxCharacters: Int
        
        /// Maximum allowed media attachments per Status
        let maxMediaAttachments: Int
        
        /// Each URL will be worth this many characters in a Status
        let charactersReservedPerUrl: Int
    }
    
    /// Hints and limits for which Media Attachments an instance will accept
    struct MediaAttachmentPolicy: Codable
    {
        /// Supported MIME types
        let supportedMimeTypes: [String]
        
        /// Maximum size of uploaded images (in bytes)
        let imageSizeLimit: Int
        
        /// Maximum total pixels (width times height) of uploaded images
        let imageMatrixLimit: Int
        
        /// Maximum size of uploaded videos (in bytes)
        let videoSizeLimit: Int
        
        /// Maximum framerate of uploaded videos
        let videoFrameRateLimit: Int
        
        /// Maximum total pixels (width times height of a frame) of uploaded videos
        let videoMatrixLimit: Int
    }
    
    /// Limits relating to Polls on an Instance
    struct PollPolicy: Codable
    {
        /// Maximum number of options allowed for polls
        let maxOptions: Int
        
        /// Maximum characters allowed for each option
        let maxCharactersPerOption: Int
        
        /// Shortest allowed Poll duration, in seconds
        let minExpiration: Int
        
        /// Longest allowed Poll duration, in seconds
        let maxExpiration: Int
    }
    
    /// Policy related to translation for an Instance
    struct TranslationPolicy: Codable
    {
        /// Is the translation API enabled on this instance?
        let enabled: Bool
    }
}
