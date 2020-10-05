//
//  File.swift
//  AlbumSearch
//
//  Created by Ainizhaer Aierken on 14.11.2019.
//  Copyright © 2019 Ainizhaer Aierken. All rights reserved.
//

import Foundation
import FeedKit

let BASE_URL = "https://itunes.apple.com/search?entity=podcast&offset=0"
let ALBUM_SONGS_URL = "https://itunes.apple.com/lookup?entity=podcast&id="

class DataService {
    
    static let instance = DataService()
    var results: [[String: String]]?         // the whole array of dictionaries

    func getAlbums (searchRequest: String, withLimit: Bool, complition: @escaping ([Podcast])->()) {
        var albums = [Podcast]()
        var searchString = searchRequest.replacingOccurrences(of: " ", with: "+")
        searchString = replacingGerman(search: searchString)
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+")
        if searchString.rangeOfCharacter(from: characterset.inverted) != nil {
            searchString = ""
        }
        var url = URL(string: "\(BASE_URL)&term=\(searchString)")
        if withLimit {
            url = URL(string: "\(BASE_URL)&limit=10&term=\(searchString)")
        }
        let session = URLSession.shared
        session.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    if let albumsResults = json["results"] as? NSArray {
                        for album in albumsResults {
                            if let albumInfo = album as? [String: AnyObject] {
                                guard let artistName = albumInfo["artistName"] as? String else {return}
                                guard let collectionId = albumInfo["collectionId"] as? Int else {return}
                                guard let collectionName = albumInfo["collectionName"] as? String else {return}
                                guard let country = albumInfo["country"] as? String else {return}
                                guard let primaryGenreName = albumInfo["primaryGenreName"] as? String else {return}
                                guard let releaseDate = albumInfo["releaseDate"] as? String else {return}
                                let releaseDateFormatted = releaseDate.prefix(4)
                                let albumInstance = Podcast(collectionID: String(collectionId), artistName: artistName, collectionName: collectionName, country: country, primaryGenreName: primaryGenreName, releaseDate: String(releaseDateFormatted))
                                albums.append(albumInstance)
                            }
                        }
                        complition(albums)
                    }
                } catch {
                    log.error(error.localizedDescription)
                }
            }
            if error != nil {
                log.error(error!.localizedDescription)
            }
        }.resume()
    }
    
    func getAlbumTracks (collectionId: Int, withLimit: Bool, complition: @escaping ([Track]) -> ()) {
        var tracks = [Track]()
        let url = URL(string: "\(ALBUM_SONGS_URL)\(collectionId)")
        let session = URLSession.shared
        session.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    if let trackResults = json["results"] as? NSArray {
                        for song in trackResults {
                            // 0 element is album info
                            if let songInfo = song as? [String: AnyObject] {
                                guard let feedUrl = songInfo["feedUrl"] as? String else {return}
                                
                                let parser = FeedParser(URL: URL(string: feedUrl)!)
                                let result = parser.parse()
                                switch result {
                                case .success(let feed):
                                    // Grab the parsed feed directly as an optional rss
                                    if let items = feed.rssFeed?.items{
                                        for i in 0...items.count-1 {
                                            if withLimit && i > 10 {
                                                break
                                            }
                                            
                                            tracks.append(Track(trackName: items[i].title ?? "",trackNumber: items.count - i, trackUrl: items[i].enclosure?.attributes?.url ?? "", description: items[i].description ?? "" ))
                                        }
                                    }
                                case .failure(let error):
                                    log.error(error)
                                }
                            }
                        }
                        complition(tracks)
                    }
                } catch {
                    log.error(error.localizedDescription)
                }
            }
            if error != nil {
                log.error(error!.localizedDescription)
            }
        }.resume()
    }
    
    func replacingGerman (search: String) -> String {
        var replace = search.replacingOccurrences(of: "ä", with: "ae")
        replace = replace.replacingOccurrences(of: "ü", with: "ue")
        replace = replace.replacingOccurrences(of: "ö", with: "oe")
        replace = replace.replacingOccurrences(of: "Ä", with: "Ae")
        replace = replace.replacingOccurrences(of: "Ö", with: "Oe")
        replace = replace.replacingOccurrences(of: "Ü", with: "Ue")
        replace = replace.replacingOccurrences(of: "ß", with: "ss")
        return replace
    }
}
