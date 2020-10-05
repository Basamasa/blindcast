//
//  AppDelegate.swift
//  Blindcast
//
//  Created by Jan Anstipp on 10.12.19.
//  Copyright © 2019 handycap. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // remove all track
        do {
          let realm = try Realm()
            do {
                try realm.write {
                    let result = realm.objects(TrackModel.self)
                    realm.delete(result)
                }
            } catch _ as NSError {
            }
        } catch _ as NSError {
        }
        // track
        let saveTrack = TrackModel()
        if let track = MediaPlayer.instance.track {
            if let player = MediaPlayer.instance.player {
                saveTrack.trackName = track.trackName
                saveTrack.trackNumber = track.trackNumber
                saveTrack.trackUrl = track.trackUrl
                saveTrack.description1 = track.description
                saveTrack.currentTime = player.currentTime().seconds
            }
        }
        // save as first
        do {
          let realm = try Realm()
            do {
                try realm.write {
                    realm.add(saveTrack)
                }
            } catch _ as NSError {
            }
        } catch _ as NSError {
        }
    }
}
