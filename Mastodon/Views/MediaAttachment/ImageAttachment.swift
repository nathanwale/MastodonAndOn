//
//  ImageAttachment.swift
//  Mastodon
//
//  Created by Nathan Wale on 21/9/2023.
//

import SwiftUI

///
/// Image Attachment Views
///
struct ImageAttachment
{
    /// Image view from URL
    static func imageView(url: URL) -> some View
    {
        WebImage(url: url)
    }
    
    ///
    /// Preview view
    /// - url: Source of image
    ///
    struct Preview: View
    {
        /// Source of Image
        let imageUrl: URL
       
        /// Main view
        var body: some View
        {
            ImageAttachment.imageView(url: imageUrl)
        }
    }
    
    ///
    /// Expanded view
    /// - url: Source of image
    /// - description: Description of image
    ///
    struct Expanded: View
    {
        /// Source of Image
        let imageUrl: URL
        
        /// Description of image
        let description: String?
        
        /// Main view
        var body: some View
        {
            VStack(spacing: 0)
            {
                ZoomAndPan
                {
                    ImageAttachment.imageView(url: imageUrl)
                }
                Spacer()
                descriptionLabel
            }
        }
        
        /// Description Label
        @ViewBuilder
        var descriptionLabel: some View
        {
            if let description {
                HStack
                {
                    Spacer()
                    ExpandableText(description)
                    Spacer()
                }
                .padding(5)
                .background(.black.opacity(0.75))
                .foregroundStyle(.white)
            }
        }
    }
}


// MARK: - Previews
#Preview
{
    let attachment = MastodonMediaAttachment.previewImageAttachment
    return VStack
    {
        ImageAttachment.Preview(imageUrl: attachment.url)
        Text("Preview")
        ImageAttachment.Expanded(imageUrl: attachment.url, description: attachment.description)
        Text("Expanded")
    }
}
