//
//  default.swift
//  Blindcast
//
//  Created by Jan Anstipp on 09.02.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import Foundation
import SwiftUI

struct TabItem: View{
    let title: LocalizedStringKey
    let lable: LocalizedStringKey
    let hint: LocalizedStringKey
    let size: CGFloat
    
    var body: some View{
        ZStack{
            Rectangle().foregroundColor(Color.black.opacity(0))
            Text(title)
        }
        .accessibilityElement(children: .combine)
        .accessibility(label: Text(lable))
        .accessibility(hint: Text(hint))
        .accessibility(addTraits: .startsMediaSession)
    }
}

struct BlindcastView2: View{
    @EnvironmentObject var mainModel: MainViewModel
//    @EnvironmentObject var appState: AppState
    
    var size: CGFloat = 50
    var body: some View{
        VStack{
            selectetView()
            HStack{
                TabItem(title: "blindcastView.player",
                        lable:"blindcastView.player.label",
                        hint: "",//"blindcastView.player.hint",
                        size: size)
                    .onTapGesture { self.mainModel.selectedTab = .player }
                    .onLongPressGesture { self.mainModel.player.togglePlay() }
                    .accessibility(addTraits: .startsMediaSession)
                TabItem(title: "blindcastView.library",
                        lable:"blindcastView.library.label",
                        hint: "",//blindcastView.library.hint",
                        size: size)
                    .onTapGesture { self.mainModel.selectedTab = .library(search: "") }
                    .onLongPressGesture {
                        self.mainModel.voice.startSpeechRecognition(onSpeechRecognitionFinished: { (result) in
                            self.mainModel.selectedTab = .library(search: result) })}
                    .accessibility(addTraits: .startsMediaSession)
                
                TabItem(title: "blindcastView.search",
                        lable:"blindcastView.search.label",
                        hint: "",//"blindcastView.search.hint",
                        size: size)
                    .onTapGesture { self.mainModel.selectedTab = .search(search: "") }
                    .onLongPressGesture {
                        self.mainModel.voice.startSpeechRecognition(onSpeechRecognitionFinished: { (result) in
                            self.mainModel.selectedTab = .search(search: result) })}
                TabItem(title: "blindcastView.voice",
                        lable: "blindcastView.voice.label",
                        hint: "blindcastView.voice.hint",
                        size: size)
                    .onTapGesture { self.mainModel.voice.startGlobalSpeechRecognition() }
                    .accessibility(addTraits: .startsMediaSession)
            }.frame(height:size, alignment: .center)
        
        }
    }
    
    var player: some View{ PlayerView(player: mainModel.player).environmentObject(mainModel)}
    var libary: some View{ PodcastListView(mainModel: mainModel,
                                           podcastList: $mainModel.podcastLibary,
                                           header: "podcastList.header.abo",
                                           headerHint: "podcastList.header.abo.hint")} //LibraryView(mainModel: mainModel)}
    var search: some View{ SearchView(mainModel: mainModel)}
    var voiceView: some View{ VoiceView(mainModel: mainModel, voice: mainModel.voice)}
    
    func selectetView() -> AnyView {
        switch mainModel.selectedTab{
        case .player: return AnyView( player)
        case let .library(value):
            mainModel.filterPodcast(value)
            return AnyView( libary )
        case let .search(value):
            mainModel.searchPodcast1(value)
            return AnyView( search)
        case .speech: return AnyView( voiceView )
        case .load: return AnyView( Text("Load") )
        }
    }
}

enum Tab: Hashable {
    case player
    case library(search: String)
    case search(search: String)
    case speech
    case load
}



