//
//  PreviewModels.swift
//  Mastodon
//
//  Created by Nathan Wale on 19/9/2023.
//

import Foundation

fileprivate let sampleUserId = "110528637375951012" // this is @nwale
fileprivate let sampleHost = "mastodon.social"
fileprivate let sampleAccessKey = Secrets.previewAccessToken

// MARK: - convenience functions
extension JsonLoader
{
    /// Load JSON data from preview folder.
    /// - filename: name of file without extension
    ///
    static func fromSample<T: Decodable>(_ filename: String) -> T
    {
        let fileUrl = Bundle.main.url(forResource: filename, withExtension: "json")!
        return JsonLoader.fromLocalUrl(fileUrl)
    }
}
// MARK: - sample accounts
extension MastodonAccount
{
    /// Sample account
    static var sample: Self {
        return JsonLoader.fromSample("single-account")
    }
}

// MARK: - Preview statuses
extension MastodonStatus
{
    /// Sample Statuses for previews
    static var previews: [MastodonStatus] {
        return JsonLoader.fromSample("multiple-statuses")
    }
    
    /// Sample Status for previews
    static var preview: MastodonStatus {
        return previews[0]
    }
    
    /// Sample Context
    static var previewContext: MastodonStatus.Context {
        return JsonLoader.fromSample("status-context")
    }
}

// MARK: - sample timeline requests
extension UserTimelineRequest
{
    /// Online user
    static func sampleFetch() async throws -> [MastodonStatus]
    {
        return try await Self.sample.send()
    }
    
    /// Sample user statuses request
    static var sample: Self
    {
        Self(host: sampleHost, userid: sampleUserId, accessToken: nil)
    }
}

extension PublicTimelineRequest
{
    /// Sample user statuses request
    static var sample: Self
    {
        Self(host: sampleHost, accessToken: nil)
    }
}

extension HomeTimelineRequest
{
    /// Sample home timeline
    static var sample: Self
    {
        Self(host: sampleHost, accessToken: sampleAccessKey)
    }
    
    /// Sample home timeline UNAUTHORISED.
    /// For testing unauthorised access UI
    static var sampleUnauthorised: Self
    {
        Self(host: sampleHost, accessToken: "unauthorised-token")
    }
}

// MARK: - Preview attachments
extension MastodonMediaAttachment
{
    /// Sample Attachments for previews
    static var previews: [MastodonMediaAttachment] {
        return JsonLoader.fromSample("multiple-attachments")
    }
    
    /// Sample Image Attachment for previews
    static var previewImageAttachment: MastodonMediaAttachment {
        return previews[0]
    }
}

// MARK: - Preview custom emoji
extension MastodonCustomEmoji
{
    ///Sample emojis
    static var samples: [Self] {
        JsonLoader.fromSample("multiple-emojis")
    }
}


// MARK: - mock request api
struct MockRequestApi: MastodonStatusRequest
{
    var host: String = ""
    var timeFrame: ApiQueryTimeFrame?
    var endpoint = Endpoint.none
    var accessToken: AccessToken? { nil }
}


// MARK: - instance preview
extension MastodonInstance
{
    static var sample: Self {
        JsonLoader.fromSample("instance-data")
    }
}


// MARK: - notifications preview
extension MastodonNotification
{
    static var samples: [Self] {
        JsonLoader.fromSample("notifications")
    }
}
