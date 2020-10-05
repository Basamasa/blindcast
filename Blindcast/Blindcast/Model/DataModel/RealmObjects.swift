//
//  RealmObjects.swift
//  Blindcast
//
//  Created by Jan Anstipp on 14.12.19.
//  Copyright © 2019 handycap. All rights reserved.
//

import Foundation
import RealmSwift

extension Int{
    func toString() -> String{
        return "\(self)"
    }
}

extension Double{
    func toString() -> String{
        return "\(self)"
    }
}

extension Bool{
    func toString() -> String{
        return "\(self)"
    }
}

class ObjectEncoder{
    
    static func encode(media: Media) throws -> some Object{
        let wrapper = media.wrapperType
        switch wrapper {
        case "track":
            return encodeTrack(media)
        default:
            throw ObjectEncodeError.invalidWrapper
        }
    }
    
    static func encodeTrack(_ media: Media) -> some Object{
        return MedieaRealmO.initMedia(media: media)
    }
        
    static func encodeMediamedia(_ media: Media) -> some Object{
        let newMedia = MedieaRealmO()
        newMedia.id = media.id.uuidString
        newMedia.wrapperType = media.wrapperType
        newMedia.kind = media.kind
        newMedia.artistID = media.artistID?.toString()
        newMedia.collectionID = media.collectionID?.toString()
        newMedia.trackID = media.trackID?.toString()
        newMedia.artistName = media.artistName
        newMedia.collectionName = media.collectionName
        newMedia.trackName = media.trackName
        newMedia.collectionCensoredName = media.collectionCensoredName
        newMedia.trackCensoredName = media.trackCensoredName
        newMedia.artistViewUrl = media.artistViewUrl
        newMedia.collectionViewUrl = media.collectionViewUrl
        newMedia.trackViewUrl = media.trackViewUrl
        newMedia.previewUrl = media.previewUrl
        newMedia.artworkUrl30 = media.artworkUrl30
        newMedia.artworkUrl60 = media.artworkUrl60
        newMedia.artworkUrl100 = media.artworkUrl100
        newMedia.collectionPrice = media.collectionPrice?.toString()
        newMedia.trackPrice = media.trackPrice?.toString()
        newMedia.releaseDate = media.releaseDate
        newMedia.collectionExplicitness = media.collectionExplicitness
        newMedia.trackExplicitness = media.trackExplicitness
        newMedia.discCount = media.discCount?.toString()
        newMedia.discNumber = media.discNumber?.toString()
        newMedia.trackCount = media.trackCount?.toString()
        newMedia.trackNumber = media.trackNumber?.toString()
        newMedia.trackTimeMillis = media.trackTimeMillis?.toString()
        newMedia.country = media.country
        newMedia.currency = media.currency
        newMedia.primaryGenreName = media.primaryGenreName
        newMedia.isStreamable = media.isStreamable?.toString()
        newMedia.collectionHDPrice = media.collectionHDPrice?.toString()
        newMedia.trackHDPrice = media.trackHDPrice?.toString()
        newMedia.contentAdvisoryRating = media.contentAdvisoryRating
        newMedia.shortDescription = media.shortDescription
        newMedia.longDescription = media.longDescription
        newMedia.collectionArtistName = media.collectionArtistName
        newMedia.collectionArtistID = media.collectionArtistID?.toString()
        newMedia.collectionArtistViewURL = media.collectionArtistViewURL
        return newMedia
    }
}

class MedieaRealmO: Object{
    @objc dynamic var id: String = "fail"
    @objc dynamic var wrapperType: String = ""
    @objc dynamic var kind: String? = ""
    @objc dynamic var artistID: String? = ""
    @objc dynamic var collectionID: String? = ""
    @objc dynamic var trackID: String? = ""
    @objc dynamic var artistName: String? = ""
    @objc dynamic var collectionName: String? = ""
    @objc dynamic var trackName: String? = ""
    @objc dynamic var collectionCensoredName: String? = ""
    @objc dynamic var trackCensoredName: String? = ""
    @objc dynamic var artistViewUrl: String? = ""
    @objc dynamic var collectionViewUrl: String? = ""
    @objc dynamic var trackViewUrl: String? = ""
    @objc dynamic var previewUrl: String? = ""
    @objc dynamic var artworkUrl30: String? = ""
    @objc dynamic var artworkUrl60: String? = ""
    @objc dynamic var artworkUrl100: String? = ""
    @objc dynamic var collectionPrice: String? = ""
    @objc dynamic var trackPrice: String? = ""
    @objc dynamic var releaseDate: String? = ""
    @objc dynamic var collectionExplicitness: String? = ""
    @objc dynamic var trackExplicitness: String? = ""
    @objc dynamic var discCount: String? = ""
    @objc dynamic var discNumber: String? = ""
    @objc dynamic var trackCount: String? = ""
    @objc dynamic var trackNumber: String? = ""
    @objc dynamic var trackTimeMillis: String? = ""
    @objc dynamic var country: String? = ""
    @objc dynamic var currency: String? = ""
    @objc dynamic var primaryGenreName: String? = ""
    @objc dynamic var isStreamable: String? = ""
    @objc dynamic var collectionHDPrice: String? = ""
    @objc dynamic var trackHDPrice: String? = ""
    @objc dynamic var contentAdvisoryRating: String? = ""
    @objc dynamic var shortDescription: String? = ""
    @objc dynamic var longDescription: String? = ""
    @objc dynamic var collectionArtistName: String? = ""
    @objc dynamic var collectionArtistID: String? = ""
    @objc dynamic var collectionArtistViewURL: String? = ""

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
    
    static func initMedia(media: Media) -> MedieaRealmO {
        let newMedia = MedieaRealmO()
        newMedia.id = media.id.uuidString
        newMedia.wrapperType = media.wrapperType
        newMedia.kind = media.kind
        newMedia.artistID = media.artistID?.toString()
        newMedia.collectionID = media.collectionID?.toString()
        newMedia.trackID = media.trackID?.toString()
        newMedia.artistName = media.artistName
        newMedia.collectionName = media.collectionName
        newMedia.trackName = media.trackName
        newMedia.collectionCensoredName = media.collectionCensoredName
        newMedia.trackCensoredName = media.trackCensoredName
        newMedia.artistViewUrl = media.artistViewUrl
        newMedia.collectionViewUrl = media.collectionViewUrl
        newMedia.trackViewUrl = media.trackViewUrl
        newMedia.previewUrl = media.previewUrl
        newMedia.artworkUrl30 = media.artworkUrl30
        newMedia.artworkUrl60 = media.artworkUrl60
        newMedia.artworkUrl100 = media.artworkUrl100
        newMedia.collectionPrice = media.collectionPrice?.toString()
        newMedia.trackPrice = media.trackPrice?.toString()
        newMedia.releaseDate = media.releaseDate
        newMedia.collectionExplicitness = media.collectionExplicitness
        newMedia.trackExplicitness = media.trackExplicitness
        newMedia.discCount = media.discCount?.toString()
        newMedia.discNumber = media.discNumber?.toString()
        newMedia.trackCount = media.trackCount?.toString()
        newMedia.trackNumber = media.trackNumber?.toString()
        newMedia.trackTimeMillis = media.trackTimeMillis?.toString()
        newMedia.country = media.country
        newMedia.currency = media.currency
        newMedia.primaryGenreName = media.primaryGenreName
        newMedia.isStreamable = media.isStreamable?.toString()
        newMedia.collectionHDPrice = media.collectionHDPrice?.toString()
        newMedia.trackHDPrice = media.trackHDPrice?.toString()
        newMedia.contentAdvisoryRating = media.contentAdvisoryRating
        newMedia.shortDescription = media.shortDescription
        newMedia.longDescription = media.longDescription
        newMedia.collectionArtistName = media.collectionArtistName
        newMedia.collectionArtistID = media.collectionArtistID?.toString()
        newMedia.collectionArtistViewURL = media.collectionArtistViewURL
        return newMedia
    }
    
    override static func primaryKey() -> String? {
      return "id"
    }
}

enum ObjectEncodeError: Error {
    case invalidWrapper
}
