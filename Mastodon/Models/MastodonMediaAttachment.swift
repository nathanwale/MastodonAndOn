//
//  MastodonMediaAttachment.swift
//  Mastodon
//
//  Created by Nathan Wale on 13/9/2023.
//

import Foundation

typealias MastodonMediaAttachmentId = String

///
/// Media Attachment on a Mastodon Status
///
struct MastodonMediaAttachment: Codable, Equatable, Identifiable
{
    /// Identifier of attachment in database
    var id: MastodonMediaAttachmentId
    
    /// Media type of attachment
    var type: MediaType
    
    /// Location of the full-size attachment
    var url: URL
    
    /// Location of a preview of the attachment
    var previewUrl: URL
    
    /// The location of the full-size original attachment on the remote website.
    ///  Nil if local
    var remoteUrl: URL?
    
    /// Metadata as a Dictionary
    var meta: Meta?
    
    /// Alt. text for vision impaired and when media is yet to load
    /// Is optional, despite what the docs say
    var description: String?
    
    /// Visual hash of media computed by the [BlurHash](https://github.com/woltapp/blurhash) algorithm
    var blurhash: String?
    
    ///
    /// Media type of attachment
    ///
    enum MediaType: String, Codable
    {
        /// unsupported or unrecognized file type
        case unknown = "unknown"
        
        /// Static image
        case image = "image"
        
        /// Looping, soundless animation
        case gifv = "gifv"
        
        /// Video clip
        case video = "video"
        
        /// Audio track
        case audio = "audio"
    }
    
    ///
    /// Meta information
    /// (Only some parts are decoded)
    /// 
    struct Meta: Codable, Equatable
    {
        /// Length of media as string
        let length: String?
        
        /// Length of media in seconds
        let duration: Double?
        
        /// Aspect ratio
        let aspect: Double?
    }
}
