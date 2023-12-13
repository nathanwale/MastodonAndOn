//
//  MastodonAccountTests.swift
//  Mastodon
//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import Mastodon

final class MastodonInstanceTests: XCTestCase
{
    var instance: MastodonInstance!
    
    override func setUp() async throws 
    {
        let fileUrl = Bundle(for: Self.self).url(forResource: "instance-data", withExtension: "json")!
        instance = JsonLoader.fromLocalUrl(fileUrl)
    }
    
    func testDecodeInstanceFromJson() throws
    {
        XCTAssertEqual(instance.domain, "mastodon.social")
        XCTAssertEqual(instance.title, "Mastodon")
        XCTAssertEqual(instance.version, "4.2.1+pr-27634-22407c7")
        XCTAssertEqual(instance.sourceUrl.description, "https://github.com/mastodon/mastodon")
        
        // Usage
        let usage = instance.usage
        XCTAssertEqual(usage.users.activeMonth, 276655)
        
        // Thumbnail
        let thumb = instance.thumbnail
        XCTAssertEqual(thumb.url.description, "https://files.mastodon.social/site_uploads/files/000/000/001/@1x/57c12f441d083cde.png")
        XCTAssertEqual(thumb.blurhash, "UeKUpFxuo~R%0nW;WCnhF6RjaJt757oJodS$")
        XCTAssertEqual(thumb.versions?.singleResolution?.description,
                       "https://files.mastodon.social/site_uploads/files/000/000/001/@1x/57c12f441d083cde.png")
        XCTAssertEqual(thumb.versions?.doubleResolution?.description,
                       "https://files.mastodon.social/site_uploads/files/000/000/001/@2x/57c12f441d083cde.png")
        
        // Languages
        XCTAssertEqual(instance.languages, ["en"])
        
        // Registrations
        let registrations = instance.registrations
        XCTAssertEqual(registrations.approvalRequired, false)
        XCTAssertEqual(registrations.enabled, true)
        XCTAssertEqual(registrations.message, nil)
        XCTAssertNil(registrations.url)
        
        // Contact
        let contact = instance.contact
        XCTAssertEqual(contact.email, "staff@mastodon.social")
        XCTAssertEqual(contact.account.displayName, "Mastodon")
        XCTAssertEqual(contact.account.id, "13179")
        
        // Rules
        let rules = instance.rules
        XCTAssertEqual(rules.count, 5)
        
        let rule = rules[4]
        XCTAssertEqual(rule.id, "7")
        XCTAssertEqual(rule.text, "Do not share intentionally false or misleading information")
    }
    
    func testDecodeInstanceConfigurationFromJson() throws
    {
        let config = instance.configuration
        
        // URLs
        let urls = config.urls
        XCTAssertEqual(urls.streaming?.description, "wss://streaming.mastodon.social")
        XCTAssertEqual(urls.status?.description, "https://status.mastodon.social")
        XCTAssertEqual(urls.streamingApi, nil)
        
        // account policy
        let accounts = config.accounts
        XCTAssertEqual(accounts.maxFeaturedTags, 10)
        
        // status policy
        let statuses = config.statuses
        XCTAssertEqual(statuses.maxCharacters, 500)
        XCTAssertEqual(statuses.maxMediaAttachments, 4)
        XCTAssertEqual(statuses.charactersReservedPerUrl, 23)
        
        // media attachment policy
        let attachments = config.mediaAttachments
        XCTAssertEqual(attachments.imageSizeLimit, 16777216)
        XCTAssertEqual(attachments.imageMatrixLimit, 33177600)
        XCTAssertEqual(attachments.videoSizeLimit, 103809024)
        XCTAssertEqual(attachments.videoFrameRateLimit, 120)
        XCTAssertEqual(attachments.videoMatrixLimit, 8294400)
        
        //... MIME types
        let mimeTypes = attachments.supportedMimeTypes
        XCTAssertEqual(mimeTypes.count, 28)
        XCTAssertEqual(mimeTypes.last, "video/x-ms-asf")
        
        // poll policy
        let polls = config.polls
        XCTAssertEqual(polls.maxOptions, 4)
        XCTAssertEqual(polls.maxCharactersPerOption, 50)
        XCTAssertEqual(polls.minExpiration, 300)
        XCTAssertEqual(polls.maxExpiration, 2629746)
        
        // translation policy
        let translation = config.translation
        XCTAssertEqual(translation.enabled, true)
    }
    
    func testRemoteFetchInstance() async throws
    {
        let request = InstanceRequest(host: MastodonInstance.defaultHost)
        let instance = try await request.send()
        XCTAssertEqual(instance.title, "Mastodon")
    }
}
