//
//  KeychainToken.swift
//  Mastodon
//
//  Created by Nathan Wale on 11/1/2024.
//

import Foundation

///
/// An item stored on the Keychain
///     adapted from https://stackoverflow.com/questions/68209016/store-accesstoken-in-ios-keychain
///
struct KeychainToken
{
    /// Access token for OAuth
    static var accessToken: Self {
        Self(identifier: "mastodon-access-token")
    }
    
    /// Service name to store under.
    static let serviceName = "com.nathanwale.mastodonandon.token-storage"
    
    /// String encoding
    static let stringEncoding = String.Encoding.utf8
    
    /// Error type
    enum Error: LocalizedError
    {
        /// Error attempting to store item
        case storeItemFailed(OSStatus)
        
        /// Item is already on keychain
        case insertingDuplicateItem
        
        /// Error retrieving item
        case retrieveItemFailed(OSStatus)
        
        /// Error retrieving item
        case updateItemFailed(OSStatus)
        
        /// Item not found
        case itemNotFound
        
        /// Error deleting item
        case deleteItemFailed(OSStatus)
        
        /// Query Parameter error
        case invalidParameters(OSStatus)
    }
    
    /// Query type
    typealias Query = CFDictionary
    
    /// Token name.
    /// These MUST be unique
    let identifier: String
    
    /// Query to add this item to Keychain
    func addQuery(token: String) -> Query
    {
        [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: Self.serviceName,
            kSecAttrAccount: identifier,
            kSecValueData: token.data(using: Self.stringEncoding)!,
        ] as CFDictionary
    }
    
    /// Query to retrieve an item
    var getQuery: Query {
        [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: Self.serviceName,
            kSecAttrAccount: identifier,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true,
        ] as CFDictionary
    }
    
    /// Query to update item
    var updateQuery: Query {
        [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: Self.serviceName,
            kSecAttrAccount: identifier,
        ] as CFDictionary
    }
    
    /// Query to delete item
    var deleteQuery: Query {
        [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: Self.serviceName,
            kSecAttrAccount: identifier,
        ] as CFDictionary
    }
    
    /// Store item on Keychain
    func insert(_ token: String) throws
    {
        // attempt to add and get status
        let status = SecItemAdd(addQuery(token: token), nil)
        
        // was there an error?
        guard status == errSecSuccess else {
            switch status {
                case errSecParam:
                    throw Error.invalidParameters(status)
                case errSecDuplicateItem:
                    throw Error.insertingDuplicateItem
                default:
                    throw Error.storeItemFailed(status)
            }

        }
    }
    
    /// Retrieve item from Keychain
    /// May throw KeychainItem.Error
    /// `nil` if token isn't stored in Keychain
    func retrieve() throws -> String?
    {
        // reference for item
        var result: AnyObject?
        
        // attempt to retrieve item and get status
        let status = SecItemCopyMatching(getQuery as CFDictionary, &result)
        
        // was there an error?
        guard status == errSecSuccess else {
            switch status {
                case errSecItemNotFound:
                    // no item in keychain, return nil
                    return nil
                case errSecParam:
                    throw Error.invalidParameters(status)
                default:
                    // else other error
                    throw Error.retrieveItemFailed(status)
            }
        }
        
        return String(data: result as! Data, encoding: Self.stringEncoding)!
    }
    
    ///
    /// Update token
    ///
    func update(_ token: String) throws
    {
        let attributes = [
            kSecValueData: token.data(using: Self.stringEncoding)
        ] as CFDictionary
        
        // attempt to update
        let status = SecItemUpdate(updateQuery, attributes)
        
        // was there an error?
        guard status == errSecSuccess else {
            switch status {
                case errSecItemNotFound:
                    // no item in keychain
                    throw Error.itemNotFound
                case errSecParam:
                    throw Error.invalidParameters(status)
                default:
                    // else other error
                    throw Error.updateItemFailed(status)
            }
        }
    }
    
    ///
    /// Update or insert token
    ///
    func updateOrInsert(_ token: String) throws
    {
        if try retrieve() == nil {
            // token is new, so insert
            try insert(token)
        } else {
            // token exists, so update
            try update(token)
        }
    }
    
    ///
    /// Delete tokan from Keychain
    ///
    func delete() throws
    {
        let status = SecItemDelete(deleteQuery)
        
        guard 
            status == errSecSuccess
            || status == errSecItemNotFound
        else {
            switch status {
                case errSecParam:
                    throw Error.invalidParameters(status)
                default:
                    throw Error.deleteItemFailed(status)
            }
        }
    }
}
