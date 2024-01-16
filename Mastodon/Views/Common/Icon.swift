//
//  SwiftUIView.swift
//  Mastodon
//
//  Created by Nathan Wale on 21/9/2023.
//

import SwiftUI

///
/// Common icons for use in UI
///
enum Icon: String, CaseIterable
{
    case reblog = "arrow.uturn.up.circle"
    case altText = "text.bubble.fill"
    case showText = "text.magnifyingglass"
    case replies = "bubble.left.and.bubble.right"
    case reply = "plus.bubble"
    case favourite = "star"
    case share = "square.and.arrow.up"
    case smile = "face.smiling"
    case notFound = "questionmark.square.dashed"
    case chevronDown = "chevron.down"
    case chevronUp = "chevron.up"
    case serverSuccess = "checkmark.icloud.fill"
    case serverProblem = "exclamationmark.icloud.fill"
    case serverRetry = "arrow.clockwise.icloud.fill"
    case serverConnect = "link.icloud.fill"
    case notification = "exclamationmark.bubble"
    case user = "person.circle"
    case `public` = "globe"
    case timeline = "sparkles.rectangle.stack"
}

// Icon extensions
extension Icon
{
    /// Icon as SwiftUI Image
    var image: some View {
        Image(systemName: self.rawValue)
    }
    
    /// Icon as UIImage
    var uiImage: UIImage? {
        UIImage(systemName: self.rawValue)
    }
    
    /// Icon as ImageResource
    var resource: ImageResource {
        ImageResource(name: rawValue, bundle: Bundle.main)
    }
}


// MARK: - previews
#Preview
{
    let grids = [GridItem(), GridItem()]
    return LazyVGrid(columns: grids)
    {
        ForEach(Icon.allCases, id: \.self)
        {
            icon in
            VStack
            {
                icon.image.imageScale(.large)
                Text(icon.rawValue).font(.caption)
            }
            .padding()
        }
    }
}
