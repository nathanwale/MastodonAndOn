//
//  PreviewModels.swift
//  Mastodon
//
//  Created by Nathan Wale on 19/9/2023.
//

import Foundation

fileprivate let sampleUserId = "110528637375951012" // this is @nwale
fileprivate let sampleHost = "mastodon.social"

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
    /// Sample Emoji
    static let sampleEmojis = [
        "smile": URL(string: "https://files.mastodon.social/cache/custom_emojis/images/000/736/060/original/8297d56b528eb387.gif"),
        "ablobcatangel": URL(string: "https://files.mastodon.social/cache/custom_emojis/images/000/471/468/original/db6a6fc28fd8387d.png"),
        "nonbinary_flag": URL(string: "https://files.mastodon.social/cache/custom_emojis/images/000/444/562/original/2e03a662e42f72c9.png"),
        "blobcatrainbow": URL(string: "https://files.mastodon.social/cache/custom_emojis/images/000/067/996/original/bab6232f6464d285.png"),
    ]
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
    static let sample: Self = JsonLoader.fromSample("instance-data")
}
