//
//  AudioAttachmentView.swift
//  Mastodon
//
//  Created by Nathan Wale on 2/2/2024.
//

import SwiftUI
import AVKit
import CoreMedia

///
/// Audio attachment view, including audio controls
///
struct AudioAttachmentView
{
    ///
    /// Preview view
    ///
    struct Preview: View
    {
        let totalTimeFormatted: String?
        /// Main view
        var body: some View
        {
            HStack
            {
                Spacer()
                Icon.audio.image
                Text(totalTimeFormatted ?? "--:--:--")
                Spacer()
            }
        }
    }
    
    struct Expanded: View 
    {
        /// State of play
        enum PlayState
        {
            case reset
            case playing
            case paused
        }
        
        /// Tracking state
        enum TrackingState
        {
            case notTracking
            case wasPlaying
            case wasPaused
        }
        
        /// Source of audio
        let url: URL
        
        /// Audio player
        let player: AVPlayer
        
        /// Timer for updating current time
        let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        
        /// Current play state
        @State var playState = PlayState.reset
        
        /// Current tracking state
        @State var trackingState = TrackingState.notTracking
        
        /// Current time in seconds
        @State var currentSeconds = 0.0
        
        /// Total time in seconds
        @State var totalSeconds = 0.0
        
        /// Current audio time formatted
        var currentTimeFormatted: String {
            formatSeconds(currentSeconds)
        }

        /// Total audio time formatted
        var totalTimeFormatted: String {
            formatSeconds(totalSeconds)
        }
        
        /// Init with URL
        init(url: URL)
        {
            self.url = url
            self.player = .init(url: url)
        }
        
        /// Turn total seconds into "MM:SS.x" format
        func formatSeconds(_ totalSeconds: Double) -> String
        {
            let formatter = DateComponentsFormatter()
            let time = TimeInterval(totalSeconds)
            var fractionalSeconds = ""
            
            if time.hours > 0 {
                formatter.allowedUnits = [.hour, .minute, .second]
            } else {
                formatter.allowedUnits = [.minute, .second]
                
                let numberFormatter = NumberFormatter()
                numberFormatter.minimumFractionDigits = 1
                numberFormatter.maximumFractionDigits = 1
                numberFormatter.maximumIntegerDigits = 0
                numberFormatter.alwaysShowsDecimalSeparator = false
                
                // gets the subseconds
                let subSeconds = NSNumber(value: totalSeconds.truncatingRemainder(dividingBy: 1.0))
                
                fractionalSeconds = numberFormatter.string(from: subSeconds) ?? ""
            }
            formatter.zeroFormattingBehavior = .pad
            
            return formatter.string(from: totalSeconds)! + fractionalSeconds
        }
        
        /// Play track
        func play()
        {
            player.play()
            playState = .playing
            
            // Announce we're playing to other media players
            NotificationCenter.default.postMediaIsPlaying(url: url)
        }
        
        /// Pause track
        func pause()
        {
            player.pause()
            playState = .paused
        }
        
        /// Play if paused and pause if playing
        func togglePlay()
        {
            switch playState {
                case .playing:
                    pause()
                case .paused, .reset:
                    play()
            }
        }
        
        /// Pause and reset to start
        func reset()
        {
            player.pause()
            player.seek(to: .zero)
            playState = .reset
            currentSeconds = 0.0
        }
        
        /// Audio tracker was dragged/updated
        func trackerWasUpdated(isEditing: Bool)
        {
            // slider is being moved
            if isEditing {
                // store play state so we can restore it later
                trackingState = switch playState {
                    case .reset, .paused:
                        .wasPaused
                    case .playing:
                        .wasPlaying
                }
                // pause while we're moving the tracker
                pause()
            }
            // slider has finished moving
            else
            {
                // update player
                player.seek(to: .init(seconds: currentSeconds, preferredTimescale: 1))
                
                switch trackingState
                {
                    // if we move the tracker, it's no longer at 'reset'
                    case .wasPaused:
                        print("pausing")
                        pause()
                                                
                    // else we play
                    case .wasPlaying:
                        print("playing")
                        play()
                        
                    // shouldn't happen
                    case .notTracking:
                        break
                }
                
                // we're no longer tracking
                trackingState = .notTracking
            }
        }
        
        // MARK: - subviews
        /// Main view
        var body: some View
        {
            playerView
        }
        
        /// Audio player view
        var playerView: some View
        {
            VStack
            {
                audioControls
            }
            .padding(5.0)
            .background(Color.black)
            .task
            {
                // Load total time of audio
                if let duration = try? await player.currentItem?.asset.load(.duration) {
                    totalSeconds = CMTimeGetSeconds(duration)
                }
            }
            .onReceive(timer)
            {
                _ in
                if playState == .playing {
                    currentSeconds = CMTimeGetSeconds(player.currentTime())
                }
            }
            .onAppear
            {
                NotificationCenter.default.addMediaIsPlayingObserver(url: url, onMediaPlaying: pause)
            }
            .onDisappear
            {
                NotificationCenter.default.removeMediaIsPlayingObserver()
                pause()
            }
        }
        
        /// Symbol name for Play/Pause button
        var playPauseSymbolName: String
        {
            switch playState {
                case .playing:
                    "pause"
                case .paused, .reset:
                    "play"
            }
        }
        
        /// Title for Play/Pause button
        var playPauseTitle: String
        {
            switch playState {
                case .playing:
                    "Pause"
                case .paused, .reset:
                    "Play"
            }
        }
        
        /// Play/Pause button
        var playPauseButton: some View
        {
            Button(playPauseTitle, systemImage: playPauseSymbolName, action: togglePlay)
        }
        
        /// Reset button
        var resetButton: some View
        {
            Button("Reset", systemImage: Icon.reset.rawValue, action: reset)
                .foregroundStyle(playState == .reset ? .gray : .white)
                .disabled(playState == .reset)
        }
        
        /// Audio controls: Buttons, tracker, time info
        var audioControls: some View
        {
            HStack
            {
                resetButton
                playPauseButton
                    .foregroundStyle(.white)
                slider
                Spacer()
                timeLabel
            }
            .labelStyle(.iconOnly)
        }
        
        /// Slider for reporting and changing position in audio
        var slider: some View
        {
            Slider(
                value: $currentSeconds,
                in: 0...totalSeconds,
                onEditingChanged: trackerWasUpdated)
        }
        
        /// Reports time as "MM:SS.s"
        var timeLabel: some View
        {
            Text(currentTimeFormatted)
                .foregroundStyle(.white)
            + Text(" / ")
                .foregroundStyle(.white.opacity(0.5))
            + Text(totalTimeFormatted)
                .foregroundStyle(.white)
        }
        
        /// Error message
        var problem: some View
        {
            Text("Unable to play audio")
        }
    }
    
    
}


// MARK: - previews
#Preview {
    let url = MastodonMediaAttachment.previewAudioAttachment.url
    let length = MastodonMediaAttachment.previewAudioAttachment.meta?.length
    return VStack
    {
        AudioAttachmentView.Preview(totalTimeFormatted: length)
        Text("Preview")
        AudioAttachmentView.Expanded(url: url)
        Text("Expanded")
    }
}
