//
//  Logger.swift
//  Blindcast
//
//  Created by Damian Framke on 07.02.20.
//  Copyright © 2020 handycap. All rights reserved.
//


import SwiftyBeaver


public let log = SwiftyBeaver.self

extension BaseDestination.LevelColor {
    mutating func applyDefaultStyle() {
        debug   = "🐞 "
        info    = "ℹ️ "
        verbose = "⚪️ "
        error   = "🔥 "
        warning = "⚠️ "
    }
}

public class LogHelper {
    public static func setup() {
        setupConsoleDestination()
        setupOSLogDestination()
    }

    public static func setupConsoleDestination() {
        let destination = ConsoleDestination()
        destination.levelColor.applyDefaultStyle()
        destination.minLevel = .verbose
        destination.asynchronously = false
        log.addDestination(destination)
    }

    public static func setupOSLogDestination() {
        let destination = OSLogDestination()
        destination.minLevel = .verbose
        destination.asynchronously = false
        log.addDestination(destination)
    }
}
