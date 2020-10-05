//
//  EpisodeListView.swift
//  Blindcast
//
//  Created by Jan Anstipp on 20.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import SwiftUI

struct EpisodeListView: View {
    @Binding
    var episodenList: [Episode]
    
    @Binding
    var searchState: String
    
    let header: LocalizedStringKey = "episodeList.header"
    let headerHint: LocalizedStringKey = "episodeList.header.hint"
    
    var body: some View {
        VStack {
            List {
                ForEach(episodenList) { episode in
                    NavigationLink(destination: EpisodeDetailView(episode: episode)) {
                        Text(episode.title).accessibility(hint: Text("episodeList.episode.hint") )
                    }.accessibility(removeTraits: .isButton)
                }
            }
        }.modifier(BlindNavigationView(label: header, hint: headerHint, isBack: true))
    }
}

struct EpisodeListView_Previews: PreviewProvider {
    @State
    static var episoden: [Episode] = []
    
    @State
    static var searchState: String = ""
    
    static var previews: some View {
        EpisodeListView(episodenList: $episoden,searchState: $searchState)
    }
}
