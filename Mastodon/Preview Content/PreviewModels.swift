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

// MARK: - sample errors
struct SampleError: Error, LocalizedError
{
    var errorDescription: String? {
        "Oh no! Something terrible has happened! Not really, this is a sample error."
    }
}

extension Error
{
    static var sample: Error {
        SampleError()
    }
}

// MARK: - sample accounts
extension MastodonAccount
{
    /// Sample ID
    static let sampleIdentifier = sampleUserId
    
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

extension HashtagTimelineRequest
{
    /// Sample hashtag timeline
    static var sample: Self
    {
        .init(host: sampleHost, tag: "catsofmastodon")
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
    
    /// Sample Video attachment
    static var previewVideoAttachment: MastodonMediaAttachment {
        return previews[2]
    }
    
    /// Sample Audio attachment
    static var previewAudioAttachment: MastodonMediaAttachment {
        return previews[4]
    }
}

extension [MastodonMediaAttachment]
{
    /// Sample Image Attachment for previews
    static var previews: Self {
        return MastodonMediaAttachment.previews
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

extension [MastodonCustomEmoji]
{
    ///Sample emojis
    static var samples: Self {
        MastodonCustomEmoji.samples
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

// MARK: - poll sample
extension MastodonPoll
{
    static var sample: Self {
        JsonLoader.fromSample("single-poll")
    }
}

// MARK: - preview card sample
extension MastodonPreviewCard
{
    static var samples: [Self] {
        JsonLoader.fromSample("multiple-preview-cards")
    }
}
