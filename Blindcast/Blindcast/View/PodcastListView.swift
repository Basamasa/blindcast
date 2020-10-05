//
//  PodcastListView.swift
//  Blindcast
//
//  Created by Jan Anstipp on 20.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import SwiftUI
import UIKit

struct PodcastListView: View {
    @ObservedObject
    var mainModel: MainViewModel
    
    @Binding
    var podcastList: [Podcast]
    
    let header: LocalizedStringKey
    let headerHint: LocalizedStringKey
    @State var searchTerm: String = ""
    
    var body: some View {
        NavigationView{
        List {
            TextField("podcastList.search", text: $mainModel.searchPodcastLibaryState)
            .accessibility(addTraits: .isSearchField)
            .accessibility(hint: Text("podcastList.search.hint"))
            
            ForEach(podcastList.filter{
                mainModel.searchPodcastLibaryState.isEmpty ? true : $0.collectionName.localizedCaseInsensitiveContains(mainModel.searchPodcastLibaryState)})
             { podcast in
                NavigationLink(destination: PodcastDetailView(podcast: podcast,
                                                              trackList: self.$mainModel.trackList,
                                                              trackState: self.$mainModel.trackState)) {
                    Text(podcast.collectionName).accessibility(hint: Text("podcastList.podcast.hint"))
                }.accessibility(removeTraits: .isButton)
            }
        }   .modifier(BlindNavigationView(label: header, hint: headerHint, isBack: true))
            .resignKeyboardOnDragGesture()
            .onAppear(){
                self.mainModel.fetchPodcastLibrary()
            }
        }
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
//
//struct PodcastListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PodcastListView()
//    }
//}
