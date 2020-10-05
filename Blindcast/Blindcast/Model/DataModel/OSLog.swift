//
//  OSLog.swift
//  U1_API
//
//  Created by Jan Anstipp on 01.11.19.
//  Copyright © 2019 Jan Anstipp. All rights reserved.
//

import Foundation
import RealmSwift
import os.log

class Logs {

    public static let api = OSLog(subsystem: "API", category: "API")
    public static let realmDatabase = OSLog(subsystem: "RealmDatabase", category: "Database")
    public static let menuUI = OSLog(subsystem: "MenuUI", category: "UI")
}


class arrayList{
    static func arrayToList<T>(_ value: [T]?) -> List<T>{
        let result = List<T>()
        if let value = value {
            result.append(objectsIn: value)
        }
        return result
    }

    static func listToArray<T>(_ value: List<T>?) -> [T]{
        var results = [T]()
        if let value = value {
            results.append(contentsOf: Array(value))
        }
        return results
    }
}

