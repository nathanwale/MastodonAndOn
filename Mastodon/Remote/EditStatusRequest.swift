//
//  NewStatusRequest.swift
//  Mastodon
//
//  Created by Nathan Wale on 2/4/2024.
//

import Foundation

struct EditStatusRequest: ApiRequest
{
    /// Data type of Post
    struct EditStatusData: Codable
    {
        let status: String
        let mediaIds: [String]
        let sensitive: Bool
        let spoilerText: String
        let visibility: MastodonStatus.StatusVisibility
    }
    
    /// Returns a MastodonStatus
    typealias Response = MastodonStatus
    
    /// ID of Status
    let statusId: MastodonStatus.Identifier
    
    /// Host to send request to
    let host: String
    
    /// Method must be Put
    let method: HttpMethod = .put
    
    /// Endpoint
    var endpoint: Endpoint {
        .editStatus(id: statusId)
    }
    
    /// Access token that authorises action
    let accessToken: AccessToken?
    
    /// Content of Status
    let statusContent: String
    
    /// ID of Status being replied to. Nil if not a reply
    var replyStatusId: MastodonStatus.Identifier? = nil
    
    /// Should this Status be marked sensitive?
    var isSensitive = false
    
    /// Text to show if Status is sensitive
    var spoilerText = ""
    
    /// Posting requires and idempotency key
    let requiresIdempotencyKey = true
    
    /// Post data
    var postData: Data?
    {
        let object = EditStatusData(
            status: statusContent, mediaIds: [],
            sensitive: isSensitive, spoilerText: spoilerText, 
            visibility: .public)
        
        do {
            return try JsonLoader.encoder.encode(object)
        } catch {
            print(error)
            return nil
        }
    }
}
