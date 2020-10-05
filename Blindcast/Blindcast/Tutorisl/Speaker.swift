//
//  File.swift
//  Blindcast
//
//  Created by Jan Anstipp on 07.02.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import Foundation
import AVFoundation


class Speaker {
    var speechSynthesizer = AVSpeechSynthesizer()
    var rate: Float?
    var voice: AVSpeechSynthesisVoice?
    static let instance = Speaker()
    
    var voiceList: [AVSpeechSynthesisVoice] = []
    
    private init(){
        
        fetchSetting()
        let language = getLocaleLanguage()
        voiceList = AVSpeechSynthesisVoice.speechVoices().filter{$0.language.elementsEqual(language) }
    }
    
    func fetchSetting(){
        // TODO -----
//        var defaultVoice: [String:String] = [:]
//        defaultVoice.updateValue("com.apple.ttsbundle.siri_female_de-DE_compact", forKey: "de-DE")
//        self.rate = 0.46
        let profiles = RealmDatabase.fetchStoredObjects(obecjts: [UserProfile()])
        guard let profile = profiles.first else { return }
        
        let language = getLocaleLanguage()
        guard let index = profile.voice.firstIndex(where: {$0.language.elementsEqual(language)}) else { return }
        
        let setting = profile.voice[index]
        let avVoice = AVSpeechSynthesisVoice.speechVoices().filter{$0.identifier.elementsEqual(setting.identifier) }.first
        self.voice = avVoice
        self.rate = Float(exactly: setting.speed)
        
//        if let identifier = defaultVoice[language]{
//            let filterVoice = voiceList.filter{$0.identifier.elementsEqual(identifier)}
//            if filterVoice.count > 0 {
//                self.voice = filterVoice[0]
//            }
//        }
    }

    func speech(_ value: String?, isStopp: Bool = false) {
        guard let value = value else {
            return
        }
        if isStopp {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        speechSynthesizer.speak(getUtterance( NSLocalizedString(value,comment: value)))
    }
    

    
    private func getUtterance(_ value: String) -> AVSpeechUtterance{
        let utterance = AVSpeechUtterance(string: value)
        if let rate = rate{
            utterance.rate = rate
        }
        if let voice = voice{
            utterance.voice = voice
        }
        return utterance
    }
    
    private func getLocaleLanguage() -> String {
      let locale = Locale.current
      guard let languageCode = locale.languageCode,
        let regionCode = locale.regionCode else {
          return "de-DE"
      }
      return languageCode + "-" + regionCode
    }
    

}

