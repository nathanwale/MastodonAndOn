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
    enum Token: Equatable
    {
        case lineBreak
        case text(String)
        case hashTag(name: String, url: URL?)
        case link(url: URL?)
        case mention(name: String, instance: String, url: URL?)
        case emoji(name: String)
        case bold(String)
        case italic(String)
    }
    
    /// The input type
    enum Input
    {
        case html(String)
        case plainText(String)
    }
    
    /// Input to parse
    let input: Input
    
    /// Initialise with plain String input
    init(plainText: String)
    {
        input = .plainText(plainText)
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
                
            case .plainText(let plainText):
                return parse(plainText: plainText)
        }
    }
}
