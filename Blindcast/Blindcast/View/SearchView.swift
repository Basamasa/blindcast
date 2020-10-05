//
//  SearchView.swift
//  Blindcast
//
//  Created by Jan Anstipp on 20.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject
    var mainModel: MainViewModel
    
    @State
    var hidden: Bool = false
    
    let mediaPlayer: MediaPlayer = MediaPlayer.instance
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    TextField("podcastList.search", text: $mainModel.searchPodcastString)
                        .foregroundColor(.primary)
                        .resignKeyboardOnDragGesture()
                        .padding(10)
                        .accessibility(addTraits: .isSearchField)
                        .accessibility(hint: Text("podcastList.search.hint"))
                }
                
                ForEach(self.mainModel.searchPodcastList) { podcast in
                    NavigationLink(destination: PodcastDetailView(podcast: podcast,
                                                                  trackList: self.$mainModel.trackList,
                                                                  trackState: self.$mainModel.trackState)) {
                        Text(podcast.collectionName).accessibility(hint: Text("podcastList.podcast.hint"))
                    }.accessibility(removeTraits: .isButton)
                }

                if !hidden {
                    if mainModel.searchPodcastList.count > 9 {
                        Text("blindcast.more")
                         .onTapGesture {
                                self.mainModel.fetchAllPodcast(search: self.mainModel.searchPodcastString)
                                self.hidden = true
                        }
                    }
                }
            }.modifier(BlindNavigationView(label: "search.header",
                                           hint: "search.header.hint",
                                           isBack: false))
             .resignKeyboardOnDragGesture()
             .onDisappear(perform: self.mainModel.voice.stopSpeechRecognition)
        }
    }
}
