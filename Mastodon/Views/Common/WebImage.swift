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
    
    let placeHolderGradient = LinearGradient(
        colors: [.purple, .green],
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
    
    @State private var gradientAngle = 45.0
    
    var body: some View
    {
        CachedAsyncImage(url: url) {
            $0.resizable()
        } placeholder: {
            placeHolderGradient
                .hueRotation(.degrees(gradientAngle))
                .onAppear {
                    withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
                        gradientAngle = 225.0
                    }
                }
        }
        .scaledToFit()
    }
}

struct WebImage_Previews: PreviewProvider {
    static var previews: some View {
        
        let cachedUrl = URL(string: "https://files.mastodon.social/accounts/avatars/110/528/637/375/951/012/original/2d14c64b7a9e1f10.jpeg")!
        let freshUrl = URL(string: "https://picsum.photos/1000")!
        let dannyDevito = URL(string: "https://i.imgur.com/6gfUHST.jpeg")
        VStack
        {
            HStack 
            {
                VStack {
                    WebImage(url: cachedUrl)
                    Text("Cached")
                }
                VStack {
                    WebImage(url: freshUrl)
                    Text("Fresh")
                }
            }
            HStack
            {
                VStack {
                    WebImage(url: dannyDevito)
                    Text("Danny")
                }
                VStack {
                    WebImage(url: URL(string: "https://example.com/notfound.jpeg")!)
                    Text("Not Found")
                }
            }
        }
    }
}
