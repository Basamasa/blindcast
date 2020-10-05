//
//  TrackListView.swift
//  Blindcast
//
//  Created by Jan Anstipp on 25.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import SwiftUI

struct TrackListView: View {
    
    @EnvironmentObject
    var mainModel: MainViewModel
    
    @Binding
    var trackList: [Track]
    
    @State
    var hidden: Bool = false
    
    var trackState: Int
    
    @State var searchTerm: String = ""
    
    var body: some View {
        List {
            TextField("episodeList.search", text: $searchTerm)
            .accessibility(addTraits: .isSearchField)
            .accessibility(hint: Text("episodeList.search.hint"))
            
            ForEach(trackList.filter {
                self.searchTerm.isEmpty ? true : $0.trackName.localizedCaseInsensitiveContains(self.searchTerm)
            }) { track in
                NavigationLink(destination:
                TrackDetailView(track: track, player: self.mainModel.player)) {
                    Text(track.trackName).accessibility(hint: Text("episodeList.episode.hint"))
                }
            }
            if !hidden {
                if mainModel.trackList.count > 9 {
                    Text("blindcast.more").onTapGesture {
                        self.mainModel.fetchAllTracks(trackId: self.trackState)
                        self.hidden = true
                    }
                }
            }
        }.modifier(BlindNavigationView(label: "episodeList.header",
                                       hint: "episodeList.header.hint",
                                       isBack: true))
    }
}
