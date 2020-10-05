//
//  ContentView.swift
//  Blindcast
//
//  Created by Jan Anstipp on 10.12.19.
//  Copyright © 2019 handycap. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
//    @EnvironmentObject
//    var appState: AppState
//
    @ObservedObject
    var mainModel = MainViewModel()
    
    var body: some View {
        Group{
            if mainModel.isDemo{
                TutorialView()
            }else{
                BlindcastView2()
//                    .environmentObject(appState)
                    .environmentObject(mainModel)
            }
        }
    }
    
    
//    var body: some View {
//        BlindcastView().environmentObject(appState)
//        //DemoView()
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
