//
//  MediaPlayer.swift
//  Blindcast
//
//  Created by Jan Anstipp on 25.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import MediaPlayer
import Combine

class MediaPlayer: ObservableObject{
    static let instance = MediaPlayer()
    
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var isPlaying: Bool = false
    
    @Published
    var track: Track?
    
    public var hasTrack: Bool {
        return !(track?.trackName.isEmpty ?? false)
    }
    
    func setTrack(track newTrack: Track) {
        if let track = track, track.equals(track: newTrack) {
            return
        }
        track = newTrack
        let url = URL(string: track!.trackUrl)
        self.playerItem = AVPlayerItem(url: url!)
        self.player = AVPlayer(playerItem: playerItem)
        isPlaying = false
    }
    
    func setPlayer() {
        do {
            UIApplication.shared.beginReceivingRemoteControlEvents()
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            log.error(error.localizedDescription)
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyArtist : track?.description as Any,  MPMediaItemPropertyTitle: track?.trackName as Any]

        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.preferredIntervals = [30 as NSNumber]
        commandCenter.skipBackwardCommand.preferredIntervals = [30 as NSNumber]
        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.play()
            return .success
        }
        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.stop()
            return .success
        }
        commandCenter.skipBackwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.seekBackward(duration: 30.0)
            return .success
        }
        commandCenter.skipForwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.seekForward(duration: 30.0)
            return .success
        }

    }
    
    func play() -> Bool{
        if let player = player {
            player.play()
            isPlaying = true
            setupNowPlaying()
        }
        return isPlaying
    }
    
    func stop() -> Bool{
        if let player = player {
            player.pause()
            isPlaying = false
        }
        return isPlaying
    }
    
    func togglePlay() -> Bool{
        if(isPlaying) {
            stop()
        } else {
            play()
        }
        return isPlaying
    }
    
    func play(newtrack: Track) -> Bool{
        setPlayer()
        setTrack(track: newtrack)
        return togglePlay()
    }
    
    func seekForward(duration: Double){
        if let player = player {
            let currentTime = player.currentTime()
            player.seek(to: currentTime + CMTime(seconds: duration, preferredTimescale: 1000000))
        }
    }
    
    func seekBackward(duration: Double){
        if let player = player {
            let currentTime = player.currentTime()
            player.seek(to: currentTime - CMTime(seconds: duration, preferredTimescale: 1000000))
        }
    }
    
    func speed(speed: Double){
        if let player = player {
            player.rate = Float(speed)
        }
    }
    
    func setupNowPlaying() {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = track?.trackName

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerItem?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
