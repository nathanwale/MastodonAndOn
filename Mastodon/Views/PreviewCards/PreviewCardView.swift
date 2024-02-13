//
//  PreviewCardView.swift
//  Mastodon
//
//  Created by Nathan Wale on 7/2/2024.
//

import SwiftUI

struct PreviewCardView: View 
{
    // MARK: - properties
    /// Card to display
    let card: MastodonPreviewCard
    
    /// Description of content
    var description: String? {
        guard card.description != "" else {
            return nil
        }
        return card.description
    }
    
    /// Byline
    var byline: String? {
        switch (card.authorName, card.providerName)
        {
            case ("", ""):
                nil
            case ("", let providerName):
                "Posted on \(providerName)"
            case (let authorName, ""):
                "By \(authorName)"
            default:
                "By \(card.authorName) on \(card.providerName)"
                
        }
    }
    
    // MARK: - subviews
    /// Main view
    var body: some View
    {
        HStack
        {
            VStack
            {
                // Description of preview, if available
                if let description {
                    Text(description)
                        .padding()
                }
                
                // Preview image, if available
                if let imageUrl = card.imageUrl {
                    WebImage(url: imageUrl)
                }
                
                // Byline, if available
                if let byline {
                    if card.imageUrl == nil {
                        Divider()
                            .foregroundStyle(.white)
                    }
                    HStack
                    {
                        Spacer()
                        Text(byline)
                    }
                    .padding()
                }
            }
            
            
        }
        .background(.primary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerSize: .init(width: 5, height: 5)))
    }
    
    
}


// MARK: - previews
#Preview {
    ScrollView
    {
        VStack
        {
            ForEach(MastodonPreviewCard.samples, id: \.url)
            {
                card in
                PreviewCardView(card: card)
                    .padding(.bottom, 20)
            }
        }
    }
    .padding()
}
