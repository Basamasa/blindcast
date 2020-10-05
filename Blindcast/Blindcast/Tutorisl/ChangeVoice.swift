//
//  ChangeValue.swift
//  Blindcast
//
//  Created by Jan Anstipp on 08.02.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import Foundation
import AVFoundation


class ChangeVoice: Tutorial{
    var speaker: Speaker = Speaker.instance
    var conditionList: [Condition<Int>]
    var conditionIndex: Int = 0
    
    private var list: [AVSpeechSynthesisVoice]
    private var index: Int = 0
    
    init(){
        list = speaker.voiceList
        conditionList = []
        conditionList.append(.init(
            condition: lastIndex
            ,info: "tut.voice.1.info"
            ,instructions: "tut.voice.1.instruction"
            ,completed:"tut.voice.1.completed"))
        conditionList.append(.init(
        condition: selectVoice
        ,info: "tut.voice.2.info"
         ,instructions: ""
         ,completed:""))
    }

    func next(type: GestureType) -> Bool{
        switch type {
        case .swipe(.up):
            if index > 0 {
                index = index - 1
                speaker.voice = list[index]
            }
            break
        case .swipe(.down):
            if index + 1 < list.count {
                index = index + 1
                speaker.voice = list[index]
            }
            break
        case .swipe(.right):
            return true
        default: break
        }
        let condition = conditionList[conditionIndex].condition
        let isSucces = condition(index)
        return isLastCondition(isSucces)
    }

    private func lastIndex(index: Int) -> Bool {
        if index + 1 < list.count {
            return false
        }else {
            return true
        }
    }

    private func firstIndex(index: Int) -> Bool {
        if index > 0 {
            return false
        }else {
            return true
        }
    }
   
    private func selectVoice(index: Int) -> Bool { return false }
    
    func isLastCondition(_ isCompletet: Bool) -> Bool{
        let condition = conditionList[conditionIndex]
        if let name = speaker.voice?.name {
            let voiceString = "Hallo ich bin die Stimme von \(name)"
            speaker.speech(voiceString,isStopp: true)
        }else {
            let voiceString = "Stimme"
            speaker.speech(voiceString,isStopp: true)
        }
       
        
        if !isCompletet {
            speaker.speech(condition.instructions)
            return false
        }
        
        speaker.speech(condition.completed)
           
        if conditionList.count <= conditionIndex + 1 {
            return true
        }
        
        conditionIndex = conditionIndex + 1
        let nextCondition = conditionList[conditionIndex]
        speaker.speech(nextCondition.info)
        speaker.speech(nextCondition.instructions)
        return false
    }
    
    func start() {
        speaker.speech(conditionList[0].info)
        speaker.speech(conditionList[0].instructions)
    }
}

