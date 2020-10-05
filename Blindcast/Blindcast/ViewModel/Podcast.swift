//
//  File.swift
//  Blindcast
//
//  Created by Jan Anstipp on 23.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import Foundation
import SwiftUI
import RealmSwift
import Realm

class Podcast: ObservableObject, Identifiable {
    let id: UUID = UUID()
    var collectionID: String = ""
    var artist: String = ""
    var collectionName: String = ""
    var country: String = ""
    let trailer: Track = Track(trackName: "", trackNumber: -1, trackUrl: "", description: "")
    var genre: String = ""
    var releaseDate: String = ""
    
    @Published
    var episodes: [Episode] = []
    
    @Published
    var isAbo: Bool = false {
        didSet {
            isAboKey = "podcastDetails.deabo.hint"
            if isAbo{
                isAboKey = "podcastDetails.abo.hint"
            }
        }
    }
    @Published
    var searchEpisodeState: String = ""
    
    @Published
    var isAboKey: LocalizedStringKey = "podcastDetails.abo.hint"
    
    @Published
    var tracks: [Track] = []
    
    init() {}
    
    init(collectionID: String,
         artistName: String,
         collectionName: String,
         country: String,
         primaryGenreName: String,
         releaseDate: String) {
        self.collectionID = collectionID
        self.artist = artistName
        self.collectionName = collectionName
        self.country = country
        self.genre = primaryGenreName
        self.releaseDate = releaseDate
    }
    

    func toggleAbo() {
        if (!isAbo) {
            saveToRealm()
            isAbo = true
        } else {
            deleteFromRealm()
            isAbo = false
        }
    }
    
    func checkAbo() {
        let realm = try! Realm()
        let podcastModel = realm.objects(PodcastModel.self)
        for model in podcastModel {
            if (model.collectionID == self.collectionID) {
                isAbo = true
            }
        }
    }
    
    func deleteFromRealm() {
        let realm = try! Realm()
        let realmPodcast = realm.objects(PodcastModel.self).filter{
            $0.collectionID == self.collectionID
        }
        try! realm.write {
            realm.delete(realmPodcast)
        }
    }
    
    func saveToRealm() {
        let podcastModel = PodcastModel()
        podcastModel.collectionID = self.collectionID
        podcastModel.artist = self.artist
        podcastModel.collectionName = self.collectionName
        podcastModel.country = self.country
        podcastModel.genre = self.genre
        podcastModel.releaseDate = self.releaseDate
        podcastModel.fillTracks()

        let realm = try! Realm()
        try! realm.write {
            realm.add(podcastModel)
        }
    }
    
    func fillTracks() {
        if Int(collectionID) ?? 0 > 0 {
            DataService.instance.getAlbumTracks(collectionId: Int(collectionID)!, withLimit: false) { (requestedTracks) in
                DispatchQueue.main.async {
                    self.tracks = requestedTracks
                }
            }
        }
    }
}
