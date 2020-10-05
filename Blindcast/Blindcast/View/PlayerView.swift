//
//  PlayerView.swift
//  Blindcast
//
//  Created by Jan Anstipp on 11.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import SwiftUI

struct PlayerView: View {
    @EnvironmentObject
    var mainModel: MainViewModel
    
    @ObservedObject
    var player: Player

    var body: some View {
        NavigationView {
            List {
                Text("player.titel")
                    .accessibility(label: Text(MediaPlayer.instance.track?.trackName ?? ""))
                    .accessibility(value: Text("player.titel.value"))
                Text("player.play")
                    .onTapGesture { self.player.togglePlay() }
                    .accessibility(value: Text(player.isPlayingValueKey))
                    .accessibility(hint: Text(player.isPlayingHintKey))
                Text("player.description")
                    .accessibility(value: Text(MediaPlayer.instance.track?.description ?? ""))
                    .accessibility(addTraits: .allowsDirectInteraction)
                Text("player.skip.forward")
                    .accessibility(hint: Text("player.skip.forward.hint"))
                    .onTapGesture { self.player.skip(duration: 30.0) }
                Text("player.skip.back")
                    .accessibility(hint: Text("player.skip.back.hint"))
                    .onTapGesture { self.player.skip(duration: -30.0) }
                Stepper("player.speed", value: $mainModel.player.speed, in: 0...2, step: 0.1)
                    .accessibility(value: Text("\(String(mainModel.player.speed.rounded(to: 2)))"))
                }.modifier(BlindNavigationView(label: "player.header", hint: "player.header.hint", isBack: false))
        }
    }
}
