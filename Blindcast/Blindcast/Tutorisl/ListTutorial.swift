//
//  ListTutorial.swift
//  Blindcast
//
//  Created by Jan Anstipp on 08.02.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import Foundation


class ListTutorial: Tutorial{
    var speaker: Speaker = Speaker.instance
    var conditionList: [Condition<Int>]
    var conditionIndex: Int = 0
    
    private var list: [String] = ["Element 1", "Element 2", "Element 3"]
    private var index: Int = 0
    
    init(){
        conditionList = []
        conditionList.append(.init(
            condition: lastIndex
            ,info: "tut.list.1.info"
            ,instructions: "tut.list.1.instruction"
            ,completed:"tut.list.1.completed"))
        conditionList.append(.init(
            condition: firstIndex
            ,info: "tut.list.2.info"
            ,instructions: "tut.list.2.instruction"
            ,completed:"tut.list.2.completed"))
    }

    func next(type: GestureType) -> Bool{
        switch type {
        case .swipe(.left):
            if index > 0 {
                index = index - 1
            }
            break
        case .swipe(.right):
            if index + 1 < list.count {
                index = index + 1
            }
            break
        default: break
        }
        speaker.speech(list[index], isStopp: true)
        
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
    
    func isLastCondition(_ isCompletet: Bool) -> Bool{
        let condition = conditionList[conditionIndex]

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

