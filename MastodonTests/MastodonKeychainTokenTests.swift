//
//  Created by Nathan Wale on 8/9/2023.
//

import XCTest

@testable import Mastodon

final class MastodonKeychainTokenTests: XCTestCase
{
    let keychainToken = KeychainToken(identifier: "token-tests")
    let insertValue = "insert value"
    let updateValue = "update value"
    
    override func setUp() async throws 
    {
        try keychainToken.insert(insertValue)
    }
    
    override func tearDown() async throws 
    {
        try keychainToken.delete()
    }
    
    func testRetrieveToken() throws
    {
        let retrievedToken = try keychainToken.retrieve()
        XCTAssertEqual(retrievedToken, insertValue)
    }
    
    func testUpdatetoken() throws
    {
        let retrievedToken = try keychainToken.retrieve()
        XCTAssertEqual(retrievedToken, insertValue)
        
        try keychainToken.update(updateValue)
        let updatedToken = try keychainToken.retrieve()
        XCTAssertEqual(updatedToken, updateValue)
    }
}
