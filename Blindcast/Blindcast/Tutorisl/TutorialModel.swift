//
//  TutModel.swift
//  Blindcast
//
//  Created by Jan Anstipp on 07.02.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class TutorialViewModel: ObservableObject{
    @Published var lastGestureValue: String = ""
    var touchSound: AVAudioPlayer?
    var speaker = Speaker.instance
    var lastGestureState: GestureState?
    var isTutorial = false
    var tutorial: [Tutorial] = [GestureTutorial(),ListTutorial(),ChangeVoice(),ChangeSpeed()]
    var tutorialIndex = 0
    
    func newState(_ newState: GestureState){
        lastGestureState = newState
        lastGestureValue = (lastGestureState!.type.description)
        
        if isTutorial{
            if tutorial[tutorialIndex].next(type: newState.type){
                if tutorial.count > tutorialIndex + 1{
                    tutorialIndex = tutorialIndex + 1
                    tutorial[tutorialIndex].start()
                }else{
                    isTutorial = false
                    speaker.speech("tut.end")
                    RealmDatabase.setDemo(isFinish: true)
                }
            }
        }else{
            speaker.speech(lastGestureValue, isStopp: true)
            speaker.speech("tut.end")
        }
    }
        
    func startTutorial(){
        isTutorial = true
        tutorial[tutorialIndex].start()
        
    }

}


