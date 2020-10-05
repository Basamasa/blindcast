//
//  VoiceViewModel.swift
//  Blindcast
//
//  Created by Damian Framke on 26.01.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import SwiftUI
import Speech
import Combine

final class Voice: ObservableObject {

    let mediaPlayer: MediaPlayer = MediaPlayer.instance
    
    private let bcSpeechSynthesizer = BCSpeechSynthesizer()
    private let bcSpeechRecognizer  = BCSpeechRecognizer()
    
    private var found: Bool = false
    
    private lazy var isMicrophoneAccessGranted = AVAudioSession.sharedInstance().recordPermission == .granted
    private lazy var isSpeechRecognitionAccessGranted = SFSpeechRecognizer.authorizationStatus() == .authorized
    
    public var isAuthorized: Bool {
        isMicrophoneAccessGranted && isMicrophoneAccessGranted
    }
    
//    var appState:  AppState!
    var mainModel: MainViewModel!

    init() {}
    
    public func startSpeechRecognition(onSpeechRecognitionFinished completion: @escaping (String) -> ()) {
        checkPermissions {
            if self.bcSpeechRecognizer.isRecording { self.bcSpeechRecognizer.stopRecording() }
            self.mainModel.player.stop()
            do {
                try self.bcSpeechRecognizer.startRecording(partialResults: false)
                self.bcSpeechRecognizer.onSpeechRecognitionFinished = completion
            } catch {
                log.error("starting speech recognition failied: \(error)")
            }
        }
    }
       
    public func startGlobalSpeechRecognition() {
        checkPermissions {
            if self.bcSpeechRecognizer.isRecording { self.bcSpeechRecognizer.stopRecording() }
            self.mainModel.player.stop()
            self.found = false
            do {
                try self.bcSpeechRecognizer.startRecording()
                self.bcSpeechRecognizer.onSpeechRecognitionPartialResult = { (result) in
                    if !self.found {
                        self.handlePhrases(phrase: result)
                    }
                }
            } catch {
              log.error("starting speech recognition failied: \(error)")
            }
        }
    }
    
    public func stopSpeechRecognition() {
        if !self.bcSpeechRecognizer.isRecording { return }
        bcSpeechRecognizer.stopRecording(success: false)
        if mediaPlayer.isPlaying {
            sleep(1)
            mediaPlayer.play()
        }

    }
    
    private func checkPermissions(onAccessIsAuthorized handler: @escaping () -> ()) {
        if isAuthorized {
            handler()
        } else {
            checkMicrophonePermission(handler: handler)
        }
    }

    // MARK:  - Microphone
    public func checkMicrophonePermission(handler: @escaping () -> ()) {
        switch AVAudioSession.sharedInstance().recordPermission {
            case .undetermined: onMicrophoneAccessIsUndetermined(handler: handler)
            case .granted:      onMicrphoneAccesIsGranted(handler: handler)
            case .denied:       onMicrophoneAccessIsDenied()
        @unknown default:
             log.error("unknown default")
        }
    }
    
    private func requestMicrophoneAccess(handler: @escaping () -> ()) {
        let microphoneAccessResult = bcSpeechRecognizer.requestMicrophoneAccess()
        microphoneAccessResult.onIsDenied  = onMicrophoneAccessIsDenied
        microphoneAccessResult.onIsGranted = { self.onMicrphoneAccesIsGranted(handler: handler) }
    }
    
    private func onMicrophoneAccessIsDenied() {
        bcSpeechSynthesizer.say(text: "voice.microphone.access.denied".localized())
    }

    private func onMicrophoneAccessIsUndetermined(handler: @escaping () -> ()) {
        bcSpeechSynthesizer.say(text: "voice.microphone.access.undetermined".localized()).onFinish = {
            self.requestMicrophoneAccess(handler: handler)
        }
    }
    
    private func onMicrphoneAccesIsGranted(handler: @escaping () -> ()) {
        checkSpeechRecognitionAccess(handler: handler)
    }
    
    // MARK:  - SpeechRecognition
    private func checkSpeechRecognitionAccess(handler: @escaping () -> ()) {
        switch SFSpeechRecognizer.authorizationStatus() {
            case .notDetermined: self.onSpeechRecognitionAccessIsNotDetermined(handler: handler)
            case .restricted:    self.onSpeechRecognitionAccessIsRestricted()
            case .authorized:    self.onSpeechRecognitionAccessIsAuthorized(handler: handler)
            case .denied:        self.onSpeechRecognitionAccessIsDenied()
            @unknown default:
                log.error("unknown default")
        }
    }
    
    private func requestSpeechRecognitionAccess(handler: @escaping () -> ()) {
        let speechRecognitionPermissionResult = self.bcSpeechRecognizer.requestSpeechRecognitionAccess()
        speechRecognitionPermissionResult.onIsNotDetermined = { self.onSpeechRecognitionAccessIsNotDetermined(handler: handler) }
        speechRecognitionPermissionResult.onIsRestricted    = onSpeechRecognitionAccessIsRestricted
        speechRecognitionPermissionResult.onIsAuthorized    = { self.onSpeechRecognitionAccessIsAuthorized(handler: handler) }
        speechRecognitionPermissionResult.onIsDenied        = onSpeechRecognitionAccessIsDenied
    }

    private func onSpeechRecognitionAccessIsAuthorized(handler: () -> ()) {
        handler()
    }

    private func onSpeechRecognitionAccessIsNotDetermined(handler: @escaping () -> ()) {
        bcSpeechSynthesizer.say(text: "voice.speechrecognition.access.undetermined".localized()).onFinish = {
            self.requestSpeechRecognitionAccess(handler: handler)
        }
    }

    private func onSpeechRecognitionAccessIsDenied() {
        bcSpeechSynthesizer.say(text: "voice.speechrecognition.authorization.denied".localized())
    }

    private func onSpeechRecognitionAccessIsRestricted() {
        bcSpeechSynthesizer.say(text: "voice.speechrecognition.authorization.denied".localized())
    }
    
    private func onFoundPhrase(silent: Bool = false, pause: Bool = true, success: Bool = true) {
        self.found = true
        bcSpeechRecognizer.stopRecording(silent: silent, success: success)
        if pause {
            sleep(1)
        }
    }
    
    private func handlePhrases(phrase: String) {
        switch phrase.lowercased() {
            case "stop", "stoppen", "halt", "pause", "pausieren":
                onFoundPhrase()
                mediaPlayer.stop()
            case "play", "start", "abspielen", "weiter":
                onFoundPhrase()
                mediaPlayer.play()
            case "vorspulen":
                onFoundPhrase()
                mediaPlayer.seekForward(duration: 30.0)
                mediaPlayer.play()
            case "zurückspulen":
                onFoundPhrase()
                mediaPlayer.seekBackward(duration: 30.0)
                mediaPlayer.play()
            case "suchen", "suche", "finden":
                onFoundPhrase(pause: false)
                bcSpeechSynthesizer.say(text: "voice.command.search".localized()).onFinish = {
                    do {
                        try self.bcSpeechRecognizer.startRecording(partialResults: false)
                        self.bcSpeechRecognizer.onSpeechRecognitionFinished = { (result) in
                            self.bcSpeechSynthesizer.say(text: "voice.command.search.found".localizedWithFormat(with: result)).onFinish = {
                                self.mainModel?.selectedTab = Tab.search(search: result)
                            }
                        }
                    } catch {
                        log.error("starting speech recognition failied: \(error)")
                    }
                }
            default:
                if mediaPlayer.isPlaying{
                    onFoundPhrase(pause: false, success: false)
                    mediaPlayer.play()
                }
        }
    }
}
