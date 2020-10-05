//
//  PodcastDetailsView.swift
//  Blindcast
//
//  Created by Jan Anstipp on 11.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import SwiftUI
import Foundation

struct PodcastDetailView: View {
    
    @EnvironmentObject
    var mainModel: MainViewModel
    
    @ObservedObject
    var podcast: Podcast
    
    @Binding
    var trackList: [Track]
    
    @Binding
    var trackState: Int
    
    var body: some View {
        List {
            Text("podcastDetails.titel").accessibility(value: Text(podcast.collectionName))
            NavigationLink(destination: TrackListView(trackList: $trackList, trackState: trackState)) {
                Text("podcastDetails.episode").accessibility(hint: Text("podcastDetails.episode.hint"))
            }.accessibility(removeTraits: .isButton)
             .onDisappear {
                self.trackState = Int(self.podcast.collectionID) ?? 0
            }
//            Text("podcastDetails.trailer")
//                .accessibility(hint: Text("podcastDetails.trailer.hint"))
//                .onTapGesture {
//                    //Player play trailer
//            }
            if self.podcast.isAbo {
                Text("podcastDetails.abo.not").onTapGesture {
                    self.podcast.toggleAbo()
                    self.mainModel.fetchPodcastLibrary()
                }.accessibility(label: Text(podcast.isAboKey))
                 .accessibility(hint: Text("podcastDetails.abo.hint"))
            } else {
                Text("podcastDetails.abo")
                    .onTapGesture { self.podcast.toggleAbo() }
                    .accessibility(label: Text(podcast.isAboKey))
                    .accessibility(hint: Text("podcastDetails.deabo.hint"))
            }
                
            Text("podcastDetails.artist").accessibility(value: Text(podcast.artist))
            
            Text("podcastDetails.grene").accessibility(value: Text(podcast.genre))
        }.modifier(BlindNavigationView(label: "podcastDetails.header",
                                       hint: "podcastDetails.header.hint",
                                       isBack: true))
         .onAppear()    {
            self.podcast.checkAbo()
        }
         .onDisappear() { self.mainModel.fetchPodcastLibrary() }
    }
}

//struct PodcastDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        PodcastDetailView(podcast: Podcast(), episodeList: <#Binding<[Track]>#>, episodeState: <#Binding<Int>#>)
//    }
//}
