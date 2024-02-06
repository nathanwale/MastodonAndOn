//
//  VideoAttachementView.swift
//  Mastodon
//
//  Created by Nathan Wale on 1/2/2024.
//

import SwiftUI
import AVKit

struct VideoAttachmentView: View
{
    /// Source URL for video
    let url: URL
    
    /// Preview image URL
    let previewUrl: URL
    
    /// Aspect ratio
    var aspectRatio = 1.0
    
    /// AV Player
    let player: AVPlayer
    
    /// Should we show the play button?
    @State private var isPlaying = false
    
    /// Notification info
    var notificationInfo: [String: URL] {
        ["url": url]
    }
    
    /// Init with URL, preview URL and optional aspect ratio
    init(url: URL, previewUrl: URL, aspectRatio: Double = 1.0)
    {
        self.url = url
        self.previewUrl = previewUrl
        self.player = AVPlayer(url: url)
    }
    
    /// Body view
    var body: some View
    {
        VStack
        {
            if isPlaying {
                videoPlayer
            } else {
                overlay
            }
        }
        .aspectRatio(aspectRatio, contentMode: .fill)
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
                }
                print("Playing video \(player.currentItem?.description ?? "<<NONE>>")")
            }
            .onDisappear {
                NotificationCenter.default.removeMediaIsPlayingObserver()
            }
    }
    
    /// Play button overlay
    @ViewBuilder
    var overlay: some View
    {
        ZStack
        {
            // Preview image
            WebImage(url: previewUrl)
            
            // Play button
            Icon.play.image
                .resizable()
                .scaledToFit()
                .scaleEffect(0.5)
                .foregroundStyle(.white.opacity(0.75))
                .shadow(radius: 10)
        }
        .onTapGesture {
            isPlaying = true
        }
    }
    
//    /// Post notification that media has begun playing
//    func postNotification()
//    {
//        NotificationCenter.default.post(
//            name: Keys.beganPlayingMediaNotification,
//            object: nil,
//            userInfo: notificationInfo)
//        print("Posting notification for \(player.currentItem?.description ?? "<<NONE>>")")
//    }
//    
//    /// Add Observer to notify that media is being played
//    /// Stop playing if notification is for a different player
//    func addObserver()
//    {
//        NotificationCenter.default.addObserver(
//            forName: Keys.beganPlayingMediaNotification,
//            object: nil,
//            queue: nil)
//        {
//            notification in
//                        
//            if let notifiedUrl = notification.userInfo?["url"] as? URL
//            {
//                // pause this player, if another player has started
//                if notifiedUrl != url {
//                    player.pause()
//                    isPlaying = false
//                    print("Pausing video for \(notifiedUrl)")
//                }
//            } else {
//                print("Notification object is not an AVPlayerItem")
//            }
//        }
//    }
//    
//    /// Remove observer
//    func removeObserver()
//    {
//        NotificationCenter.default.removeObserver(
//            self, name: Keys.beganPlayingMediaNotification, object: nil)
//    }
}


// MARK: - previews
#Preview
{
    VStack(spacing: 20)
    {
        
        VideoAttachmentView(
            url: URL(string: "https://files.mastodon.social/media_attachments/files/022/546/306/original/dab9a597f68b9745.mp4")!,
            previewUrl: URL(string: "https://files.mastodon.social/media_attachments/files/022/546/306/small/dab9a597f68b9745.png")!,
            aspectRatio: 1.333
        )
        VideoAttachmentView(
            url: URL(string: "https://files.mastodon.social/cache/media_attachments/files/111/858/806/390/635/983/original/60aafea132dd5517.mp4")!,
            previewUrl: URL(string: "https://files.mastodon.social/cache/media_attachments/files/111/858/806/390/635/983/small/60aafea132dd5517.png")!)
    }
}
