//
//  BlindcastView.swift
//  Blindcast
//
//  Created by Jan Anstipp on 10.12.19.
//  Copyright © 2019 handycap. All rights reserved.
//

import SwiftUI

struct BlindcastView: View {
    @EnvironmentObject
    var mainModel: MainViewModel
    
//    @EnvironmentObject
//    var appState: AppState

    var body: some View {
        TabView(selection: $mainModel.selectedTab) {
            PlayerView(player: mainModel.player)
                .tag(Tab.player)
                .environmentObject(mainModel)
                .tabItem({
                    Text("blindcastView.player.label")
                })
            LibraryView(mainModel: mainModel)
                .tag(Tab.library)
                .environmentObject(mainModel)
                .tabItem({
                    Text("blindcastView.library.label")
                })
                .padding(.bottom)
            SearchView(mainModel: mainModel)
                .tag(Tab.search)
                .environmentObject(mainModel)
//                .environmentObject(appState)
                .tabItem({
                    Text("blindcastView.search.label")
                })
                .padding(.bottom)
            VoiceView(mainModel: mainModel, voice: mainModel.voice)
                .tag(Tab.speech)
                .environmentObject(mainModel)
//                .environmentObject(appState)
                .tabItem({
                    Text("blindcastView.voice.label")
                })
        }.onAppear(){
            self.mainModel.setPlayer()
        }
    }
}


//  ------------------------ Preview ------------------------
struct BlindcastView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
//            BlindcastView()
//            NavigationView{ EpisodeListView() }
            Text("Test Navigation")
                .modifier(BlindNavigationView(label: "Title", hint: "Hint", isBack: true))
        }
    }
}


extension HorizontalAlignment {
    private enum MyAlignment : AlignmentID {
         static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[HorizontalAlignment.center]
        }
    }
    static let myAlignment = HorizontalAlignment(MyAlignment.self)
}
