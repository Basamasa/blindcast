//
//  TutorialProtocol.swift
//  Blindcast
//
//  Created by Jan Anstipp on 08.02.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import Foundation

protocol Tutorial {
    func start()
    func next(type:GestureType) -> Bool
    var conditionIndex: Int {get set}
    var speaker: Speaker {get set}
}


struct Condition<T> {
    var condition: (T) -> Bool
    var info: String
    var instructions: String
    var completed: String
}

