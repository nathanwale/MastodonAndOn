//
//  VideoAttachementView.swift
//  Mastodon
//
//  Created by Nathan Wale on 1/2/2024.
//

import SwiftUI
import AVKit

struct VideoAttachmentView
{
    /// Image with play button
    static func overlay(previewUrl: URL) -> some View
    {
        // Preview image
        WebImage(url: previewUrl)
            .overlay {
                // Play button
                Self.playButtonOverlay
            }
    }
    
    // Overlay of Play button
    static var playButtonOverlay: some View
    {
        Icon.play.image
            .resizable()
            .scaledToFit()
            .scaleEffect(0.5)
            .foregroundStyle(.white.opacity(0.75))
            .shadow(radius: 10)
    }
    
    ///
    /// Preview View
    /// - previewUrl: Source of preview image
    ///
    struct Preview: View 
    {
        /// Source of preview image
        let previewUrl: URL
        
        /// Formatted length of video
        let formattedLength: String?
        
        /// Main View
        var body: some View
        {
            ZStack(alignment: .bottomTrailing)
            {
                VideoAttachmentView.overlay(previewUrl: previewUrl)
                Text(formattedLength ?? "--:--:--")
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(.black.opacity(0.75))
            }
        }
    }
    
    ///
    /// Expanded View
    /// - url: Source of video
    ///
    struct Expanded: View 
    {
        /// Source of video
        let url: URL
        
        /// Source of preview image
        let previewUrl: URL
        
        /// AV Player
        let player: AVPlayer
        
        /// Should we show the play button?
        @State private var isPlaying = false
        
        /// Init with url and previewUrl
        init(url: URL, previewUrl: URL)
        {
            self.url = url
            self.previewUrl = previewUrl
            self.player = .init(url: url)
        }
        
        /// Main View
        var body: some View
        {
            VStack
            {
                if isPlaying {
                    videoPlayer
                } else {
                    VideoAttachmentView.overlay(previewUrl: previewUrl)
                        .onTapGesture {
                            isPlaying = true
                        }
                }
            }
        }
        
        /// The video player view
        var videoPlayer: some View
        {
            VideoPlayer(player: player)
                .onAppear {
                    player.seek(to: .zero)
                    player.play()
                    NotificationCenter.default.postMediaIsPlaying(url: url)
                    NotificationCenter.default.addMediaIsPlayingObserver(url: url) {
                        player.pause()
                        isPlaying = false
                        print("Playing video at \(url)")
                    }
                }
                .onDisappear {
                    NotificationCenter.default.removeMediaIsPlayingObserver()
                    player.pause()
                }
        }
    }

}


// MARK: - previews
#Preview
{
    let attachment = MastodonMediaAttachment.previewVideoAttachment
    let videoUrl = attachment.url
    let previewUrl = attachment.previewUrl
    let length = attachment.meta?.length
    
    return VStack(spacing: 20)
    {
        VideoAttachmentView.Preview(previewUrl: previewUrl, formattedLength: length)
        Text("Preview")
        VideoAttachmentView.Expanded(url: videoUrl, previewUrl: previewUrl)
        Text("Expanded")
        Spacer()
    }
}
