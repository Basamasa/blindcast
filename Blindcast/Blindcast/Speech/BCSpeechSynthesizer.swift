//
//  BCSpeechSynthesizer.swift
//  Blindcast
//
//  Created by Damian Framke on 15.12.19.
//  Copyright © 2019 Blindcast. All rights reserved.
//

import AVFoundation

class BCSpeechSynthesizer: NSObject, AVSpeechSynthesizerDelegate {
    
    private let avSpeechSynthesizer = AVSpeechSynthesizer()
    public var onFinish: (() -> ())?
    
    private let germanSiriSpeechVoiceIdentifier = "com.apple.ttsbundle.siri_female_de-DE_compact"
    
    public override init() {
        super.init()
        avSpeechSynthesizer.delegate = self
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.onFinish?()
        self.onFinish = nil
    }
    
    @discardableResult
    public func say(text: String) -> Self {
        return self.speak(text: text)
    }
    
    @discardableResult
    public func say(text: [String]) -> Self {
        return self.speak(text: text.joined(separator: " "))
    }
    
    private func speak(text: String) -> Self {
        var speechSynthesisVoice: AVSpeechSynthesisVoice?
        if Locale.current.identifier == "de_DE", #available(iOS 9.0, *) {
            speechSynthesisVoice = AVSpeechSynthesisVoice(identifier: germanSiriSpeechVoiceIdentifier)
        } else {
            speechSynthesisVoice = AVSpeechSynthesisVoice(language: Locale.current.languageCode)
        }
        let utterance    = AVSpeechUtterance(string: text)
        utterance.voice  = speechSynthesisVoice
        utterance.rate   = AVSpeechUtteranceMaximumSpeechRate / 2.5
        utterance.volume = 1.0
        
        avSpeechSynthesizer.speak(utterance)
        return self
    }
    
    public func stopSpeaking() {
        avSpeechSynthesizer.stopSpeaking(at: .immediate)
    }
}
