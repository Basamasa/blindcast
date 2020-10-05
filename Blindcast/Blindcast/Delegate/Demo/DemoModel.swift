//
//  Model.swift
//  Blindcast
//
//  Created by Jan Anstipp on 03.12.19.
//  Copyright © 2019 Jan Anstipp. All rights reserved.
//

import Foundation
import Alamofire
import AppleiTunesSearchURLComponents


class DemoModel: ObservableObject{
    
    private let database: RealmDatabase = RealmDatabase()
    @Published var podcast: [Media] = []
    @Published var podcastTitle: [Media] = []
    @Published var podcastAuthor: [Media] = []
    @Published var podcastGenre: [Media] = []

    
    @Published var search: String = "" {
        didSet{
            fetchPodcast(term: search)
        }
    }
    @Published var searchTitle: String = "" {
        didSet{
            fetchPodcastByTitle(term: searchTitle)
        }
    }
    @Published var searchAuthor: String = "" {
        didSet{
            fetchPodcastByAuthor(term: searchAuthor)
        }
    }
    @Published var searchGenre: String = "" {
        didSet{
            fetchPodcastByGenre(term: searchGenre)
        }
    }
    
    
    
    private func fetchPodcast(term: String) {
        ITunesSearchAPI.fetchMedia(mediaType: Podcast.self, term: term, entity: .podcast){ data in
            self.podcast.removeAll()
            self.podcast.append(contentsOf: data)
            let x = data.map(MedieaRealmO.initMedia(media:))
            self.database.savaRealmObjects(objects: x)
        }
    }
    
    private func fetchPodcastByTitle(term: String) {
        ITunesSearchAPI.fetchMedia(mediaType: Podcast.self, term: term, entity: .podcast, attribut: .title){ data in
            
            self.podcastTitle.append(contentsOf: data)
            let x = data.map(MedieaRealmO.initMedia(media:))
            self.database.savaRealmObjects(objects: x)
        }
    }
    
    private func fetchPodcastByAuthor(term: String) {
        ITunesSearchAPI.fetchMedia(mediaType: Podcast.self, term: term, entity: .podcast, attribut: .author){ data in
            self.podcastAuthor.removeAll()
            self.podcastAuthor.append(contentsOf: data)
            let x = data.map(MedieaRealmO.initMedia(media:))
            self.database.savaRealmObjects(objects: x)
        }
    }
    
    //TODO API Gibt keine Podcast zurück
    private func fetchPodcastByGenre(term: String) {
        ITunesSearchAPI.fetchMedia(mediaType: Podcast.self, term: term, entity: .podcast, attribut: .genre){ data in
            self.podcastGenre.removeAll()
            self.podcastGenre.append(contentsOf: data)
            let x = data.map(MedieaRealmO.initMedia(media:))
            self.database.savaRealmObjects(objects: x)
        }
    }
}
