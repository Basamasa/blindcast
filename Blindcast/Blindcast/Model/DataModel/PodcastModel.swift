//
//  PodcastModel.swift
//  Blindcast
//
//  Created by Anzer Arkin on 01.02.20.
//  Copyright © 2020 handycap. All rights reserved.
//
import RealmSwift

class PodcastModel: Object, ObservableObject{
    @objc dynamic var collectionID: String = ""
    @objc dynamic var  artist: String = ""
    @objc dynamic var  collectionName: String = ""
    @objc dynamic var  country: String = ""
    @objc dynamic var  genre: String = ""
    @objc dynamic var  releaseDate: String = ""
    var tracks = List<TrackModel>()
    
    func fillTracks() {
        if Int(collectionID) ?? 0 > 0 {
            DataService.instance.getAlbumTracks(collectionId: Int(collectionID)!, withLimit: false) { (requestedTracks) in
                DispatchQueue.main.async {
                    let curTracks = List<TrackModel>()
                    for track in requestedTracks {
                        let addTrack = TrackModel()
                        addTrack.trackName = track.trackName
                        addTrack.trackNumber = track.trackNumber
                        addTrack.trackUrl = track.trackUrl
                        addTrack.description1 = track.description
                        curTracks.append(addTrack)
                    }
                    self.tracks = curTracks
                }
            }
        }
    }
}
