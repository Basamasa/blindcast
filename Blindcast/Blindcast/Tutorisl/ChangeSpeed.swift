//
//  ChangeSpeed.swift
//  Blindcast
//
//  Created by Jan Anstipp on 08.02.20.
//  Copyright © 2020 handycap. All rights reserved.
//


import Foundation
import AVFoundation


class ChangeSpeed: Tutorial{
    var speaker: Speaker = Speaker.instance
    var conditionList: [Condition<Int>]
    var conditionIndex: Int = 0
    
    private var list: [Float] = [0.5,0.55,0.6,0.65,0.7,0.75]
    private var index: Int = 0
    
    init(){
        conditionList = []
        conditionList.append(.init(
            condition: lastIndex
            ,info:"tut.speed.1.info"
            ,instructions: ""
            ,completed:""))
    }

    func next(type: GestureType) -> Bool{
        switch type {
        case .swipe(.up):
            if index > 0 {
                index = index - 1
            }
            break
        case .swipe(.down):
            if index + 1 < list.count {
                index = index + 1
            }
            break
        case .swipe(.right):
            return true
        default: break
        }
        speaker.rate = list[index]
        
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
        let speed = String(format: "%.0f", list[index] * 100 )
        let voiceString = "tut.speed"
        speaker.speech(voiceString,isStopp: true)
        speaker.speech(speed)
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

