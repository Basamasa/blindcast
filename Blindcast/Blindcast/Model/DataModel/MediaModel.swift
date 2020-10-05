//
//  MediaModel.swift
//  Blindcast
//
//  Created by Jan Anstipp on 06.12.19.
//  Copyright © 2019 Jan Anstipp. All rights reserved.
//

import Foundation
import RealmSwift

protocol ITunesMediaTyp: Codable, Identifiable{
}

struct ITunesCodableModel<T: ITunesMediaTyp>: Codable {
    let resultCount: Int
    let results: [T]
}


struct Media: ITunesMediaTyp{
    var id = UUID()
    let wrapperType: String
    let kind: String?
    let artistID, collectionID, trackID: Int?
    let artistName, collectionName, trackName, collectionCensoredName: String?
    let trackCensoredName: String?
    let artistViewUrl, collectionViewUrl, trackViewUrl: String?
    let previewUrl: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String?
    let collectionPrice, trackPrice: Double?
    let releaseDate: String?
    let collectionExplicitness, trackExplicitness: String?
    let discCount, discNumber, trackCount, trackNumber: Int?
    let trackTimeMillis: Int?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let isStreamable: Bool?
    let collectionHDPrice, trackHDPrice: Double?
    let contentAdvisoryRating, shortDescription, longDescription, collectionArtistName: String?
    let collectionArtistID: Int?
    let collectionArtistViewURL: String?

    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistID = "artistId"
        case collectionID = "collectionId"
        case trackID = "trackId"
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case artistViewUrl, collectionViewUrl, trackViewUrl, previewUrl, artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, releaseDate, collectionExplicitness, trackExplicitness, discCount, discNumber, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName, isStreamable
        case collectionHDPrice = "collectionHdPrice"
        case trackHDPrice = "trackHdPrice"
        case contentAdvisoryRating, shortDescription, longDescription, collectionArtistName
        case collectionArtistID = "collectionArtistId"
        case collectionArtistViewURL = "collectionArtistViewUrl"
    }
    
}

//enum Kind: String, Codable {
//    case book
//    case album
//    case coachedAudio = "coached-audio"
//    case featureMovie = "feature-movie"
//    case interactiveBooklet = "interactive-booklet"
//    case musicVideo = "music-video"
//    case pdfPodcast = "pdf podcast"
//    case podcastEpisode = "podcast-episode"
//    case softwarePackage = "software-package"
//    case song
//    case tvEpisode = "tv-episode"
//    case artistFor
//}


// MARK: - Result
struct Artist: ITunesMediaTyp {
    var id = UUID()
    let wrapperType, artistType, artistName: String
    let artistLinkUrl: String
    let artistID, amgArtistID: Int
    let primaryGenreName: String
    let primaryGenreID: Int

    enum CodingKeys: String, CodingKey {
        case wrapperType, artistType, artistName,artistLinkUrl
        case artistID = "artistId"
        case amgArtistID = "amgArtistId"
        case primaryGenreName
        case primaryGenreID = "primaryGenreId"
    }
}

