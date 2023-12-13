//
//  MastodonAccountTests.swift
//  Mastodon
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import Mastodon

fileprivate let sampleUserId = "110528637375951012" // this is @nwale
fileprivate let sampleHost = "mastodon.social"

final class MastodonOnlineStatusTests: XCTestCase
{
    
    func testOnlineStatuses() async throws
    {
        let request = UserTimelineRequest(host: sampleHost, userid: sampleUserId, accessToken: nil)
        let statuses = try await request.send()
        XCTAssertGreaterThan(statuses.count, 0)
    }
}
