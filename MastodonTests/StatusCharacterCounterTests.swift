//
//  StatusCharacterCounterTests.swift
//  MastodonTests
//
//  Created by Nathan Wale on 19/3/2024.
//

import XCTest

@testable import Mastodon

final class StatusCharacterCounterTests: XCTestCase
{
    func testCharacterCountSimple()
    {
        let counter = StatusCharacterCounter()
        XCTAssertEqual(counter.remainingCharacters(""), 500, "Nothing should be 500")
        XCTAssertEqual(counter.remainingCharacters("a"), 499, "Single character should be 499")
        XCTAssertEqual(counter.remainingCharacters("A."), 498, "'A.' should be 498")
    }
    
    func testUrlsCount()
    {
        let counter = StatusCharacterCounter()
        XCTAssertEqual(counter.remainingCharacters("https://a.com"), 477, "A URL should be worth 23 characters")
        XCTAssertEqual(counter.remainingCharacters("https://mastodon.social/publish https://a.com http://a.com"), 429, "Three URLs should be worth 69 characters (plus two spaces)")
        XCTAssertEqual(counter.remainingCharacters("https://mastodon.social/publish hello https://a.com hello http://a.com"), 417, "Three URLs should be worth 69 characters (plus two 12 characters)")
    }
    
    func testMentionsCount()
    {
        let counter = StatusCharacterCounter()
        XCTAssertEqual(counter.remainingCharacters("@example"), 492, "Should count whole mention, 8 characters")
        XCTAssertEqual(counter.remainingCharacters("@example@example.social"), 492, "Should only count the username part, 8 characters")
        XCTAssertEqual(counter.remainingCharacters("@example@example.social."), 491, "Should count the fullstop, 9 characters")
    }
    
    func testComplexStatusCount()
    {
        let counter = StatusCharacterCounter()
        let post = """
        I need to know what a custom emoji on Mastodon looks like for a project.
        https://docs.joinmastodon.org/user/posting/#text
        No one reads this, so I might as well do it here: 🏏 That's cricket!
        I am @nwale@mastodon.social. If you're already on mastodon.social, you can reference me as @nwale!
        :blobpeek: And blob cat peeking at you. Hope you're not doing anything you shouldn't. :fatyoshi:
        """
        XCTAssertEqual(counter.remainingCharacters(post), 156, "Should be 156 characters")
    }
}
