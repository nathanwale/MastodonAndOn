//
//  MediaAttachment.swift
//  Mastodon
//
//  Created by Nathan Wale on 21/9/2023.
//

import SwiftUI

struct MediaAttachmentView: View
{
    var attachment: MastodonMediaAttachment
    
    @State private var showFullDescription = false
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            attachmentView
            description
        }
    }
    
    var url: URL {
        attachment.url
    }
    
    var previewUrl: URL {
        attachment.previewUrl
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
