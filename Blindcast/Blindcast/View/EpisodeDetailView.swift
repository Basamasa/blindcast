//
//  EpisodeDetailView.swift
//  Blindcast
//
//  Created by Jan Anstipp on 20.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import SwiftUI

struct EpisodeDetailView: View{
    var episode: Episode
    var body: some View{
        List{
            Text("episodeDetails.titel")
                .accessibility(value: Text(episode.title))
            Text("episodeDetails.description")
                .accessibility(value: Text(episode.desciption))
            Text("episodeDetails.play")
                .accessibility(hint: Text("episodeDetails.play.hint"))
        }.modifier(BlindNavigationView(label: "episodeDetails.header", hint: "episodeDetails.header.hint", isBack: true))
    }
}

struct EpisodeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeDetailView(episode: Episode())
    }
}
