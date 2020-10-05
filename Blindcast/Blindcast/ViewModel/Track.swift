//
//  File.swift
//  Blindcast
//
//  Created by Jan Anstipp on 23.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import Foundation

struct Track: Identifiable{
    let id: UUID = UUID()

    var trackName: String
    var trackNumber: Int
    var trackUrl: String
    var description: String
    
    init(trackName: String, trackNumber: Int, trackUrl: String, description: String) {
        self.trackName = trackName
        self.trackNumber = trackNumber
        self.trackUrl = trackUrl
        self.description = description
    }
    
    func equals(track: Track) -> Bool{
        return trackName.elementsEqual(track.trackName) && trackNumber == track.trackNumber && trackUrl.elementsEqual(track.trackUrl) && description.elementsEqual(track.description)
    }
    
    func codeHTMLToText() -> String {
        return self.description.html2String
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
       } catch {
            log.error("HTML encoding failed: \(error)")
            return nil
       }
   }
   var html2String: String {
       return html2AttributedString?.string ?? ""
   }
}

extension String {
   var html2AttributedString: NSAttributedString? {
       return Data(utf8).html2AttributedString
   }
   var html2String: String {
       return html2AttributedString?.string ?? ""
   }
}
