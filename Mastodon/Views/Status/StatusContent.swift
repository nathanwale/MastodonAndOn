//
//  StatusContent.swift
//  Mastodon
//
//  Created by Nathan Wale on 6/10/2023.
//

import SwiftUI
import UIKit


///
/// Display the content of a Status Post
///
struct StatusContent: View
{
    /// Content as an HTML fragment
    let content: String
    
    /// Custom Emojis
    let emojis: [MastodonCustomEmoji]
    
    /// Content after being parsed
    let parsedContent: ParsedText
    
    // Take HTML fragment as init
    init(_ content: String, emojis: [MastodonCustomEmoji] = [])
    {
        self.content = content
        self.emojis = emojis
        self.parsedContent = ParsedText(html: content)
    }
        
    // Body
    var body: some View
    {
        CustomEmojiText(tokens: parsedContent.tokens, emojis: emojis)
    }
}


// MARK: - Previews
#Preview 
{
    let contents = MastodonStatus.previews.map {
        c in
        c.reblog?.content ?? c.content ?? ""
    }
    return List(contents, id: \.self)
    {
        StatusContent($0)
    }
}
