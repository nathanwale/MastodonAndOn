//
//  MediaAttachment.swift
//  Mastodon
//
//  Created by Nathan Wale on 21/9/2023.
//

import SwiftUI

///
/// View Media Attachment
///
struct MediaAttachmentView: View
{
    /// Attachment to display
    var attachment: MastodonMediaAttachment
    
    /// Should we show full description?
    @State private var showFullDescription = false
    
    /// Source URL of attachment
    var url: URL {
        attachment.url
    }
    
    /// URL of preview for Videos
    var previewUrl: URL {
        attachment.previewUrl
    }
    
    // MARK: - subviews
    /// Main view
    var body: some View
    {
        VStack(spacing: 0)
        {
            attachmentView
            description
        }
    }
    
    /// Display attachment
    @ViewBuilder
    var attachmentView: some View
    {
        switch attachment.type
        {
            case .image:
                ImageAttachment(url: url)
                
            case .audio:
                AudioAttachmentView(url: url)
                
            case .video, .gifv:
                VideoAttachmentView(
                    url: url,
                    previewUrl: previewUrl)
                
            case .unknown:
                Text("Unknown attachment")
                
        }
    }
    
    /// Description, if present
    @ViewBuilder
    var description: some View
    {
        if let text = attachment.description,
           text != ""
        {
            ExpandableText(text)
                .padding(5)
                .background(Color.black)
                .foregroundColor(.white)
        }
    }
}


// MARK: - Previews
#Preview("Image")
{
    MediaAttachmentView(attachment: .previewImageAttachment)
}

#Preview("Many")
{
    ScrollView
    {
        VStack
        {
            ForEach(MastodonMediaAttachment.previews)
            {
                attachment in
                MediaAttachmentView(attachment: attachment)
            }
        }
    }
}
