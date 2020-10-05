//
//  TrackModel.swift
//  Blindcast
//
//  Created by Anzer Arkin on 01.02.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import RealmSwift

class TrackModel: Object {
    @objc dynamic var  trackName: String = ""
    @objc dynamic var  trackNumber: Int = 0
    @objc dynamic var  trackUrl: String = ""
    @objc dynamic var  description1: String = ""
    @objc dynamic var  currentTime: Double = 0
}
