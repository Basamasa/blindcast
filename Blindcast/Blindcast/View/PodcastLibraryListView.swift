//
//  PodcastLibraryListView.swift
//  Blindcast
//
//  Created by Anzer Arkin on 01.02.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import SwiftUI

struct PodcastLibraryListView: View {
    @EnvironmentObject var mainModel: MainViewModel
    @Binding var podcastList: [PodcastModel]
    let header: LocalizedStringKey
    let headerHint: LocalizedStringKey
    @State private var searchText = ""
    var body: some View{
        List{
            // Search view
            TextField("podcastList.search", text: $searchText, onCommit: {
                self.mainModel.fetchPodcast(search: self.searchText)
            })
//                .foregroundColor(.primary)
//                .resignKeyboardOnDragGesture()
            
            ForEach(podcastList) { podcast in
                NavigationLink(destination: PodcastDetailView(podcast: podcast,trackList: podcast.trackList, trackState: self.$mainModel.trackState)){
                    Text(podcast.collectionName)
                        .accessibility(hint: Text("podcastList.podcast.hint"))
                }.accessibility(removeTraits: .isButton)
            }
        }
        .modifier(BlindNavigationView(label: header, hint: headerHint, isBack: true))
        .resignKeyboardOnDragGesture()
    }
}

