//
//  Localized.swift
//  Blindcast
//
//  Created by Damian Framke on 20.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import Foundation

/// Taken from here: https://stackoverflow.com/a/48165241
extension String {
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
    func localizedWithFormat(with arguments: CVarArg..., comment: String? = nil) -> String {
        return String(format: localized(), arguments: arguments)
    }
}
