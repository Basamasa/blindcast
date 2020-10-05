//
//  GestureTutorial.swift
//  Blindcast
//
//  Created by Jan Anstipp on 08.02.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import Foundation


class GestureTutorial: Tutorial{
    var speaker: Speaker = Speaker.instance
    var conditionList: [Condition<GestureType>]
    var conditionIndex: Int = 0
    
    init(){
        conditionList = []
        conditionList.append(.init(
            condition: isSwipeDown
            ,info: "tut.gesture.1.info"
            ,instructions: "tut.gesture.1.instruction"
            ,completed:""))
        conditionList.append(.init(
            condition: isSwipeUp
            ,info: "tut.gesture.2.info"
            ,instructions: "tut.gesture.2.instruction"
            ,completed:""))
        conditionList.append(.init(
            condition: isSwipeLeft
            ,info: "tut.gesture.3.info"
            ,instructions: "tut.gesture.3.instruction"
            ,completed:""))
        conditionList.append(.init(
            condition: isSwipeRight
            ,info: "tut.gesture.4.info"
            ,instructions: "tut.gesture.4.instruction"
            ,completed:""))
        conditionList.append(.init(
            condition: isTap
            ,info: "tut.gesture.5.info"
            ,instructions: "tut.gesture.5.instruction"
            ,completed:""))
        conditionList.append(.init(
            condition: isDobbleTap
            ,info: "tut.gesture.6.info"
            ,instructions: "tut.gesture.6.instruction"
            ,completed:""))
        conditionList.append(.init(
            condition: isDobbleTap
            ,info: "tut.gesture.7.info"
            ,instructions: "tut.gesture.7.instruction"
            ,completed:""))
    }
    
    
    func next(type: GestureType) -> Bool{
        let condition = conditionList[conditionIndex]
        let isSucces = condition.condition(type)
        
        return isLastCondition(isSucces)
    }

    func isSwipeUp(_ gesture: GestureType) -> Bool { return gesture.equals(.swipe(.up)) }
    func isSwipeDown(_ gesture: GestureType) -> Bool { return gesture.equals(.swipe(.down)) }
    func isSwipeLeft(_ gesture: GestureType) -> Bool { return gesture.equals(.swipe(.left)) }
    func isSwipeRight(_ gesture: GestureType) -> Bool { return gesture.equals(.swipe(.right)) }
    func isTap(_ gesture: GestureType) -> Bool { return gesture.equals(.tap(1, 1)) }
    func isDobbleTap(_ gesture: GestureType) -> Bool { return gesture.equals(.tap(2, 1)) }
    
    func isLastCondition(_ isCompletet: Bool) -> Bool{
           let condition = conditionList[conditionIndex]

           if !isCompletet {
               speaker.speech(condition.instructions, isStopp: true)
               return false
           }
           
           speaker.speech(condition.completed)
              
           if conditionList.count <= conditionIndex + 1 {
               return true
           }
           
        conditionIndex = conditionIndex + 1
        let nextCondition = conditionList[conditionIndex]
        speaker.speech(nextCondition.info)
//        speaker.speech(nextCondition.instructions)
        return false
    }
    func start() {
        speaker.speech(conditionList[0].info)
//        speaker.speech(conditionList[0].instructions)
    }
    
}


