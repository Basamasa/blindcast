//
//  TarckDetailView.swift
//  Blindcast
//
//  Created by Jan Anstipp on 25.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//
import SwiftUI

struct TrackDetailView: View {
    var track: Track
    
    @ObservedObject
    var player: Player
    
    var body: some View {
        List {
            Text("episodeDetails.titel")
                .accessibility(value: Text(track.trackName))
            Text("episodeDetails.description")
                .accessibility(value: Text(track.codeHTMLToText()))
//            Text("player.titel")
//                .accessibility(label: Text(player.track.trackName))
//                .accessibility(value: Text("player.titel.value"))
            Text("player.play")
                .onTapGesture { self.player.playerTrack(track: self.track)}
                .accessibility(value: Text(player.isPlayingValueKey))
                .accessibility(hint: Text(player.isPlayingHintKey))
                .accessibility(addTraits: .startsMediaSession)
        }.modifier(BlindNavigationView(label: "episodeDetails.header",
                                       hint: "episodeDetails.header.hint",
                                       isBack: true))
    }
}
