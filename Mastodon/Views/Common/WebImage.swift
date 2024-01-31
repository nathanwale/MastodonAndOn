//
//  ProfileImage.swift
//  Mastodon
//
//  Created by Nathan Wale on 19/9/2023.
//

import SwiftUI
import CachedAsyncImage

struct WebImage: View
{
    var url: URL?
    
    var body: some View
    {
        CachedAsyncImage(url: url) {
            $0.resizable()
        } placeholder: {
            Color.purple.opacity(0.1)
        }
        .scaledToFit()
    }
}

struct WebImage_Previews: PreviewProvider {
    static var previews: some View {
        
        let cachedUrl = URL(string: "https://files.mastodon.social/accounts/avatars/110/528/637/375/951/012/original/2d14c64b7a9e1f10.jpeg")!
        let freshUrl = URL(string: "https://picsum.photos/1000")!
        let dannyDevito = URL(string: "https://i.imgur.com/6gfUHST.jpeg")
        HStack {
            VStack {
                WebImage(url: cachedUrl)
                Text("Cached")
            }
            VStack {
                WebImage(url: freshUrl)
                Text("Fresh")
            }
            VStack {
                WebImage(url: dannyDevito)
                Text("Fresh")
            }
        }
    }
}
