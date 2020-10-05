//
//  File.swift
//  Blindcast
//
//  Created by Jan Anstipp on 23.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import Foundation

struct Episode: Identifiable {
    let id: UUID = UUID()
    var url: String = ""
    var title: String = ""
    var desciption: String = ""
    var trackName: String = ""
    var trackNumber: Int = -1
    var trackUrl: String = ""

}
