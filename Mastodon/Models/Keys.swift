//
//  Keys.swift
//  Mastodon
//
//  Created by Nathan Wale on 4/12/2023.
//

import Foundation

///
/// Struct for storing keys and secrets
/// Sounds exciting.
///
struct Keys
{
    /// Client secret as setup on app author's Mastodon account
    static var clientSecret: String {
        deobfuscate(obfuscatedClientSecret)
    }
    
    /// Client key as setup on app author's Mastodon account
    static var clientKey: String {
        deobfuscate(obfuscatedClientKey)
    }
    
    /// Deobfuscate obfuscated keys
    static private func deobfuscate(_ obfuscated: [UInt8]) -> String
    {
        let a = obfuscated.prefix(obfuscated.count / 2)
        let b = obfuscated.suffix(obfuscated.count / 2)
        let deobfuscated = zip(a, b).map(^)
        return String(bytes: deobfuscated, encoding: .utf8)!
    }
   
}


// MARK: - obfuscated strings
/// 
/// Obfuscated keys
///
fileprivate extension Keys
{
    static let obfuscatedClientKey: [UInt8] = [210, 100, 56, 214, 233, 93, 17, 154, 228, 48, 92, 255, 129, 88, 34, 36, 141, 237, 213, 142, 196, 234, 127, 178, 173, 83, 53, 43, 232, 223, 9, 194, 0, 100, 24, 113, 132, 6, 122, 242, 192, 249, 89, 184, 40, 104, 228, 196, 31, 73, 170, 165, 127, 19, 186, 176, 111, 85, 84, 221, 166, 138, 212, 165, 217, 74, 219, 195, 31, 4, 115, 173, 150, 99, 141, 110, 11, 46, 51, 183, 100, 41, 153, 141, 140, 0]
    
    static let obfuscatedClientSecret: [UInt8] = [93, 216, 203, 52, 240, 170, 208, 92, 221, 121, 41, 137, 57, 18, 148, 124, 170, 200, 135, 66, 239, 110, 242, 243, 224, 30, 186, 252, 21, 70, 159, 68, 185, 8, 57, 50, 127, 206, 23, 179, 219, 175, 156, 7, 177, 167, 70, 178, 218, 182, 111, 150, 55, 113, 232, 102, 36, 245, 72, 227, 229, 211, 3, 140, 45, 181, 203, 174, 118, 247, 145, 80, 28, 235, 28, 208, 56, 72, 120, 75, 254, 90, 227, 188, 159, 209]
}
