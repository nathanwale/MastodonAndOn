//
//  MultipleMediaAttachment.swift
//  Mastodon
//
//  Created by Nathan Wale on 16/2/2024.
//

import SwiftUI

///
/// Display a grid of Media attachements
///
struct MultipleMediaAttachment: View
{
    // MARK: - props
    /// Attachments to display
    let attachments: [MastodonMediaAttachment]
    
    /// Max attachments that fit in an even grid
    /// For arranging in a 2 x N grid
    var maxEvenAttachments: [MastodonMediaAttachment]
    {
        if attachments.count.isMultiple(of: 2) {
            // even, return whole list
            return attachments
        } else {
            // odd, return list minus tail
            return attachments.dropLast()
        }
    }
    
    /// Tail attachment if list is odd
    var tailAttachment: MastodonMediaAttachment?
    {
        if attachments.count.isMultiple(of: 2) {
            // even, there's no tail
            return nil
        } else {
            // odd, return tail
            return attachments.last
        }
    }
    
    // MARK: - subviews
    /// Main view
    var body: some View
    {
        VStack
        {
            evenGrid
            if let tailAttachment {
                MediaAttachmentView(attachment: tailAttachment)
            }
        }
    }
    
    /// Even grid
    var evenGrid: some View
    {
        // column template
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        // grid
        return LazyVGrid(columns: columns)
        {
            ForEach(maxEvenAttachments)
            {
                attachment in
                
                VStack
                {
                    MediaAttachmentView(attachment: attachment)
                    Spacer()
                }
            }
        }
    }
}


// MARK: - previews
#Preview("Five attachments")
{
    MultipleMediaAttachment(attachments: .previews)
}

#Preview("Four attachments")
{
    MultipleMediaAttachment(attachments: .previews.dropLast())
}

#Preview("Single attachment")
{
    MultipleMediaAttachment(attachments: [.previews.first!])
}
