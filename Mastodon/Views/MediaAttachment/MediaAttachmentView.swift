//
//  MediaAttachment.swift
//  Mastodon
//
//  Created by Nathan Wale on 21/9/2023.
//

import SwiftUI

// MARK: - MediaAttachmentViewable
///
/// Protocol for Media Attachment Views
///
protocol MediaAttachmentViewable
{
    var attachment: MastodonMediaAttachment { get }
    var preview: AnyView { get }
    var expandedView: AnyView { get }
}

extension MediaAttachmentViewable
{
    /// Source URL of attachment
    var url: URL {
        attachment.url
    }
    
    /// URL of preview for Videos
    var previewUrl: URL {
        attachment.previewUrl
    }
}


// MARK: - MediaAttachmentView
///
/// View Media Attachment
///
struct MediaAttachmentView: View
{
    /// Attachment to display
    var attachment: MastodonMediaAttachment
    
    /// Should we show full description?
    @State private var showFullDescription = false
    
    /// Are we showing the expanded view?
    @State private var viewIsExpanded = false
    
    /// Source URL of attachment
    var url: URL {
        attachment.url
    }
    
    /// URL of preview for Videos
    var previewUrl: URL {
        attachment.previewUrl
    }
    
    /// Description of attachment
    var description: String? {
        attachment.description
    }
    
    /// Formatted length of media
    var formattedLength: String? {
        attachment.meta?.length
    }
    
    /// Specialised view for attachment
    @ViewBuilder
    var previewView: some View
    {
        // Have to assign attachment here
        switch attachment.type
        {
            case .image:
                ImageAttachment.Preview(imageUrl: url)
                
            case .audio:
                AudioAttachmentView.Preview(totalTimeFormatted: formattedLength)
                
            case .video, .gifv:
                VideoAttachmentView.Preview(previewUrl: previewUrl, formattedLength: formattedLength)
                
            case .unknown:
                Text("Unknown attachment")
                
        }
    }
    
    /// Specialised view for attachment
    @ViewBuilder
    var expandedView: some View
    {
        // Have to assign attachment here
        switch attachment.type
        {
            case .image:
                ImageAttachment.Expanded(imageUrl: url, description: description)
                
            case .audio:
                AudioAttachmentView.Expanded(url: url)
                
            case .video, .gifv:
                VideoAttachmentView.Expanded(url: url, previewUrl: previewUrl)
                
            case .unknown:
                Text("Unknown attachment")
        }
    }
 
    
    // MARK: - subviews
    /// Main view
    @ViewBuilder
    var body: some View
    {
        VStack
        {
            previewView
                .onTapGesture {
                    viewIsExpanded.toggle()
                }
                .sheet(isPresented: $viewIsExpanded) {
                    NavigationView
                    {
                        expandedView
                            .toolbar {
                                Button("Close")
                                {
                                    viewIsExpanded = false
                                }
                            }
                    }
                }
            descriptionView
        }
    }
  
    /// Description, if present
    @ViewBuilder
    var descriptionView: some View
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
