//
//  MainViewModel.swift
//  Blindcast
//
//  Created by Jan Anstipp on 11.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//


import RealmSwift
import SwiftUI
import Combine
import CoreMedia
import UIKit

class MainViewModel: ObservableObject {
    
    
    private var cancellable: AnyCancellable? = nil
    private let bcSpeechSynthesizer = BCSpeechSynthesizer()
    @Published var selectedTab: Tab = .player{
        didSet{}
    }
    @Published var player: Player = Player()
    @Published var voice: Voice = Voice()
    @Published var searchPodcastList: [Podcast] = []
    @Published var searchPodcastString: String = ""{
        didSet {
            fetchPodcast(search: searchPodcastString)
            self.selectedTab = .search(search: searchPodcastString)
        }
    }
    @Published var allPodcasts: [Podcast] = []
    @Published var searchEpisodeList: [Episode] = []
    @Published var searchEpisodeState: String = ""{
        didSet { searchEpisodeList = fetchEpisode(episode: searchEpisodeState) }}
 
    @Published var trackList: [Track] = []
    @Published var trackState: Int = 0 {
        didSet { fetchTrack(trackId: trackState) }}
    @Published var podcastLibary: [Podcast] = []
    @Published var searchPodcastLibaryState: String = ""
        { didSet {self.selectedTab = .library(search: searchPodcastLibaryState)} }
//        { didSet { fetchPodcastLibrary() }}
    @Published var episodenLibary: [Episode] = []
    @Published var searchEpisodenLibaryState: String = ""

    
    init() {
        voice.mainModel = self
        fetchPodcastLibrary()
//        cancellable = AnyCancellable($searchPodcastString
//            .debounce(for: 0.3, scheduler: DispatchQueue.main)
//            .removeDuplicates()
//            .sink { self.fetchPodcast(search: $0) })
        initTutorial()
    }

    func searchPodcast1(_ search :String){
        if !searchPodcastString.elementsEqual(search){
            searchPodcastString = search
        }
    }
    
    func filterPodcast(_ filter: String){
        if !searchPodcastLibaryState.elementsEqual(filter){
            searchPodcastLibaryState = filter
        }
    }
    
    func setPlayer() {
        do {
          let realm = try Realm()
            let model = realm.objects(TrackModel.self).first
            if let trackModel = model {
                let track = Track(trackName: trackModel.trackName, trackNumber: trackModel.trackNumber, trackUrl: trackModel.trackUrl, description: trackModel.description)
                self.player.setPlayer(track: track)
                MediaPlayer.instance.player?.seek(to: CMTimeMakeWithSeconds(trackModel.currentTime, preferredTimescale: 1))
            }
        } catch _ as NSError {
        }
    }
    
    func fetchPodcast(search: String) {
        if search.isEmpty {
            return self.searchPodcastList.removeAll()
        }
        DataService.instance.getAlbums(searchRequest: search, withLimit: true) { (requestedAlbums) in
            let requestAlbum = requestedAlbums.sorted(by: {$0.collectionName < $1.collectionName})
            DispatchQueue.main.async {
                self.searchPodcastList.removeAll()
                self.searchPodcastList = requestAlbum
            }
        }
    }
    
    func fetchAllPodcast(search: String) {
        if search.isEmpty {
            return self.searchPodcastList.removeAll()
        }
        DataService.instance.getAlbums(searchRequest: search, withLimit: false) { (requestedAlbums) in
            let requestAlbum = requestedAlbums.sorted(by: {$0.collectionName < $1.collectionName})
            DispatchQueue.main.async {
                self.searchPodcastList.removeAll()
                self.searchPodcastList = requestAlbum
            }
        }
    }
    
    func fetchPodcastLibrary() {
        do {
            let realm = try Realm()
            let podcastModel = realm.objects(PodcastModel.self)
            var podcasts: [Podcast] = []
            for model in podcastModel {
                let podcast = Podcast(collectionID:     model.collectionID,
                                      artistName:       model.artist,
                                      collectionName:   model.collectionName,
                                      country:          model.country,
                                      primaryGenreName: model.genre,
                                      releaseDate:      model.releaseDate)
                podcasts.append(podcast)
            }
            self.podcastLibary = podcasts
        } catch let error as NSError {
          // handle error
            print(error)
        }
    }
    
    func fetchEpisode(episode: String) -> [Episode] {
        return []
    }
    
    func fetchTrack(trackId: Int) {
        if trackId > 0 {
            DataService.instance.getAlbumTracks(collectionId: trackId, withLimit: true) { (requestedTracks) in
                DispatchQueue.main.async {
                    self.trackList.removeAll()
                    self.trackList = requestedTracks
                }
            }
        }
    }
    
    func fetchAllTracks(trackId: Int) {
        if trackId > 0 {
            DataService.instance.getAlbumTracks(collectionId: trackId, withLimit: false) { (requestedTracks) in
                DispatchQueue.main.async {
                    self.trackList.removeAll()
                    self.trackList = requestedTracks
                }
            }
        }
    }
    
    @Published var isDemo: Bool = false
    func initTutorial(){
        NotificationCenter.default.addObserver(self, selector: #selector(voiceOverDidChange), name: UIAccessibility.voiceOverStatusDidChangeNotification, object: nil)
        voiceOverDidChange()
    }
    
    @objc func voiceOverDidChange() {
        let profiles = RealmDatabase.fetchStoredObjects(obecjts: [UserProfile()])
        if let profile = profiles.first{
            isDemo = !profile.isTutorialFinish
        }else{
            isDemo = !UIAccessibility.isVoiceOverRunning
        }
    }
}
