//
//  MastodonAccountTests.swift
//  Mastodon
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import Mastodon

final class VerifyAccessTokenRequestTest: XCTestCase
{
    func testRequest() async throws
    {
        let request = VerifyAccessTokenRequest(host: MastodonInstance.defaultHost, accessToken: Secrets.previewAccessToken)
        let account = try await request.send()
        XCTAssertEqual(account.id, MastodonAccount.sampleIdentifier)
    }
}
