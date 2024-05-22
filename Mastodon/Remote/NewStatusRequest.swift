//
//  NewStatusRequest.swift
//  Mastodon
//
//  Created by Nathan Wale on 2/4/2024.
//

import Foundation

struct NewStatusRequest: ApiRequest
{
    /// Data type of Post
    struct NewStatusData: Codable
    {
        let status: String
        let mediaIds: [String]
        let inReplyToId: MastodonStatus.Identifier?
        let sensitive: Bool
        let spoilerText: String
    }
    
    /// Returns a MastodonStatus
    typealias Response = MastodonStatus
    
    /// Host to send request to
    let host: String
    
    /// Method must be Post
    let method: HttpMethod = .post
    
    /// Endpoint
    let endpoint: Endpoint = .postNewStatus
    
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
    
    let printResponse: Bool = true
    
    /// Post data
    var postData: Data?
    {
        let object = NewStatusData(
            status: statusContent, mediaIds: [], inReplyToId: replyStatusId,
            sensitive: isSensitive, spoilerText: (isSensitive ? spoilerText : ""))
        
        do {
            return try JsonLoader.encoder.encode(object)
        } catch {
            print(error)
            return nil
        }
    }
}
