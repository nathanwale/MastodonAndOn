//
//  NotificationCenter+.swift
//  Mastodon
//
//  Created by Nathan Wale on 6/2/2024.
//

import Foundation

extension NSNotification
{
    /// Audio or Video media is playing
    static let MediaIsPlaying = Notification.Name.init("MediaIsPlaying")
}

extension NotificationCenter
{
    /// Post notification that media has begun playing
    func postMediaIsPlaying(url: URL)
    {
        NotificationCenter.default.post(
            name: NSNotification.MediaIsPlaying,
            object: nil,
            userInfo: ["url": url])
        print("Posting notification for playing \(url)")
    }
    
    /// Add Observer to notify that media is being played
    /// Stop playing if notification is for a different player
    func addMediaIsPlayingObserver(url: URL, onMediaPlaying: @escaping () -> ())
    {
        NotificationCenter.default.addObserver(
            forName: NSNotification.MediaIsPlaying,
            object: nil,
            queue: nil)
        {
            notification in
                        
            if let notifiedUrl = notification.userInfo?["url"] as? URL
            {
                // run pauseHandler, if another player has started
                if notifiedUrl != url {
                    onMediaPlaying()
                    print("Pausing video for \(notifiedUrl)")
                }
            } else {
                print("Notification object is not an AVPlayerItem")
            }
        }
    }
    
    /// Remove MediaIsPlaying observer
    func removeMediaIsPlayingObserver()
    {
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.MediaIsPlaying, object: nil)
    }
}
