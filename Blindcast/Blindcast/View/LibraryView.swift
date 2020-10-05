//
//  LibraryView.swift
//  Blindcast
//
//  Created by Jan Anstipp on 20.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject
    var mainModel: MainViewModel
    
    var body: some View {
         NavigationView {
            List {
                NavigationLink(destination: PodcastListView(mainModel: mainModel, podcastList: $mainModel.podcastLibary,
                                                            header: "podcastList.header.abo",
                                                            headerHint: "podcastList.header.abo.hint")) {
                    Text("library.podcastList").accessibility(hint: Text("library.podcastList.hint"))
                }.accessibility(removeTraits: .isButton)
            }.modifier(BlindNavigationView(label: "library.header", hint: "library.header.hint", isBack: false))
         }.onAppear() {
            self.mainModel.fetchPodcastLibrary()
         }
    }
}
