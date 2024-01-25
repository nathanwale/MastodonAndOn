//
//  Mastodon
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import Mastodon

final class MastodonNotifications: XCTestCase
{
    func testDecodeNotificationsFromJson() throws
    {
        let fileUrl = Bundle(for: Self.self).url(forResource: "notifications", withExtension: "json")!
        let notifications: [MastodonNotification] = JsonLoader.fromLocalUrl(fileUrl)
        
        XCTAssertEqual(notifications.count, 27)
        
        let notification = notifications.first!
        
        XCTAssertEqual(notification.id, "234106656")
        XCTAssertEqual(notification.type, .favourite)
        XCTAssertEqual(notification.createdAt.description, "2024-01-09 14:30:32 +0000")
        XCTAssertEqual(notification.account.displayName, "If_This_Goes_On")
        XCTAssertEqual(notification.status?.id!, "111726158805380581")
    }
    
    func testNotificationsFromRemoteRequest() async throws
    {
        let request = NotificationsRequest(host: MastodonInstance.defaultHost, accessToken: Secrets.previewAccessToken)
        let notifications = try await request.send()
        
        XCTAssertGreaterThan(notifications.count, 0)
    }
}
