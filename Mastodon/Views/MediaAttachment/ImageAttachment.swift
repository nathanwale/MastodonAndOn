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

struct ImageAttachment_Previews: PreviewProvider {
    static var previews: some View {
        ImageAttachment(url: MastodonMediaAttachment.previewImageAttachment.url)
    }
}
