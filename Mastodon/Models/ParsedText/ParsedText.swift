//
//  ParsedText.swift
//  Mastodon
//
//  Created by Nathan Wale on 24/10/2023.
//

import Foundation

///
/// Text that has been parsed to find links, mentions, custom emoji, etc.
///
struct ParsedText
{
    /// The tokens that are a result of the parsing
    enum Token
    {
        case lineBreak
        case text(String)
        case hashTag(name: String, url: URL?)
        case link(url: URL?)
        case mention(name: String, url: URL?)
        case emoji(String)
    }
    
    /// The input type
    enum Input
    {
        case html(String)
        case plain(String)
    }
    
    /// Input to parse
    let input: Input
    
    /// Initialise with plain String input
    init(plain: String)
    {
        input = .plain(plain)
    }
    
    /// Initialise with HTML input
    init(html: String)
    {
        input = .html(html)
    }
    
    /// Tokens after input is parsed
    var tokens: [Token]
    {
        switch input {
            case .html(let html):
                do {
                    return try parse(html: html)
                } catch {
                    print(error)
                    return []
                }
                
            case .plain(let plainText):
                return parse(plain: plainText)
        }
    }
}
