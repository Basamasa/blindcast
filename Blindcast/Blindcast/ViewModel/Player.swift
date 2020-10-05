//
//  Player.swift
//  Blindcast
//
//  Created by Jan Anstipp on 11.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation
import UIKit
import MediaPlayer

class Player: ObservableObject {
    let mediaPlayer: MediaPlayer = MediaPlayer.instance
    
    @Published
    var track: Track
    
    @Published
    var podcast: Podcast
    
    @Published
    var isPlayingValueKey: LocalizedStringKey = "player.status.stop"
    
    @Published
    var isPlayingHintKey: LocalizedStringKey = "player.status.stop.hint"
    
    @Published var speed: Double = 1 {
        didSet {
            speed(speed: speed)
        }
    }
    
    var isPlaying: Bool = MediaPlayer.instance.isPlaying {
        didSet {
            isPlayingValueKey = "player.status.stop"
            isPlayingHintKey  = "player.status.stop.hint"
            if isPlaying {
                isPlayingValueKey = "player.status.play"
                isPlayingHintKey  = "player.status.stop.hint"
            }
        }
    }

    init() {
        podcast = Podcast()
        track = Track(trackName: "", trackNumber: -1, trackUrl: "", description: "")
    }

    func togglePlay(){
        isPlaying = mediaPlayer.togglePlay()
    }
    
    func stop(){
        isPlaying = mediaPlayer.stop()
    }
    
    func play(){
        isPlaying = mediaPlayer.play()
    }
    
    
    func playerTrack(track: Track) {
        isPlaying = mediaPlayer.play(newtrack: track)
        if let trac = mediaPlayer.track {
            self.track = trac
        }
    }
    
    func setPlayer(track: Track) {
        mediaPlayer.setPlayer()
        mediaPlayer.setTrack(track: track)
    }

    func speed(speed: Double) {
        mediaPlayer.speed(speed: speed)
    }
    
    func skip(duration: Double) {
        mediaPlayer.seekForward(duration: duration)
        if duration < 0 {
            mediaPlayer.seekBackward(duration: -duration)
        }
    }
}
