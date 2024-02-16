//
//  ImageAttachment.swift
//  Mastodon
//
//  Created by Nathan Wale on 21/9/2023.
//

import SwiftUI

struct ImageAttachment: View
{
    var url: URL
    var body: some View
    {
        WebImage(url: url)
    }
}

#Preview 
{
    let url = URL(string: "https://files.mastodon.social/accounts/avatars/110/528/637/375/951/012/original/2d14c64b7a9e1f10.jpeg")!
    
    return ImageAttachment(url: url)
}
