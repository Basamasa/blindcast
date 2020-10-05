//
//  VoiceView.swift
//  Blindcast
//
//  Created by Jan Anstipp on 20.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import SwiftUI

struct VoiceView: View {

    @ObservedObject
    var mainModel: MainViewModel
    
    @ObservedObject
    var voice: Voice
    
//    @EnvironmentObject
//    var appState: AppState

    var body: some View {
        VStack {
            Spacer()
            Text("blindcastView.voice".localized()).onTapGesture {
                self.voice.startGlobalSpeechRecognition()
            }
            
            Spacer()
            
        }.onAppear {
//            self.voice.appState = self.appState
//            self.voice.startGlobalSpeechRecognition()
        }//.onDisappear(perform:voice.stopSpeechRecognition)
    }
}
