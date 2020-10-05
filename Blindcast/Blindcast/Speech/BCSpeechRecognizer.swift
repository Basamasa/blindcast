//
//  BCSpeechRecognizer.swift
//  Blindcast
//
//  Created by Damian Framke on 01.12.19.
//  Copyright © 2019 Blindcast. All rights reserved.
//

import Speech
import UIKit

class SpeechRecognitionAccessResult {
    public var onIsNotDetermined: (() -> ())?
    public var onIsRestricted:    (() -> ())?
    public var onIsAuthorized:    (() -> ())?
    public var onIsDenied:        (() -> ())?
}

class MicrophoneAccessResult {
    public var onIsUndetermined: (() -> ())?
    public var onIsGranted:      (() -> ())?
    public var onIsDenied:       (() -> ())?
}

class BCSpeechRecognizer {
    private let currentLocale            = Locale.current
    private var speechRecognizer         : SFSpeechRecognizer!
    private var recognitionRequest       : SFSpeechAudioBufferRecognitionRequest!
    private var recognitionTask          : SFSpeechRecognitionTask?
    private let audioEngine              : AVAudioEngine?
    private var speechRecognitionTimeout : Timer?
    
    public var onSpeechRecognitionPartialResult: ((_ transcription: String) -> ())?
    public var onSpeechRecognitionFinished:      ((_ transcription: String) -> ())?
    
    private var recordingTimer:  Timer?
    private var meterLevel:      Float = 0.0
    private var meterTimerCount: Int = 0
    
    public var isRecording: Bool {
        return audioEngine?.isRunning ?? false
    }
    
    private var notifySuccess: Bool = false

    public init() {
        speechRecognizer = SFSpeechRecognizer(locale: currentLocale)
        audioEngine      = AVAudioEngine()
    }
    
    public func requestMicrophoneAccess() -> MicrophoneAccessResult {
        let microphoneAccessResult = MicrophoneAccessResult()
           AVAudioSession.sharedInstance().requestRecordPermission { granted in
               DispatchQueue.main.async {
                   if granted {
                        microphoneAccessResult.onIsGranted?()
                   } else {
                        microphoneAccessResult.onIsDenied?()
                   }
               }
           }
        return microphoneAccessResult
    }
        
    public func requestSpeechRecognitionAccess() -> SpeechRecognitionAccessResult {
        let speechRecognitionAccessResult = SpeechRecognitionAccessResult()
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                    case .notDetermined: speechRecognitionAccessResult.onIsNotDetermined?()
                    case .restricted:    speechRecognitionAccessResult.onIsRestricted?()
                    case .authorized:    speechRecognitionAccessResult.onIsAuthorized?()
                    case .denied:        speechRecognitionAccessResult.onIsDenied?()
                @unknown default:        log.error("unknow default")
                }
            }
        }
        return speechRecognitionAccessResult
    }
        
    public func startRecording(partialResults: Bool = true) throws {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.resetRecording()
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.playAndRecord,
                                     mode:    AVAudioSession.Mode.spokenAudio,
                                     options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine?.inputNode
        guard let recognitionRequest = recognitionRequest else {
            log.error("Unable to create SFSpeechAudioBufferRecognitionRequest obj")
            fatalError("Unable to create SFSpeechAudioBufferRecognitionRequest obj")
        }
        
        notifySuccess = !partialResults
        recognitionRequest.shouldReportPartialResults = partialResults
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { (result, error) in
            var isFinal = false
        
            if let result = result {
                isFinal = result.isFinal
                
                let bestString = result.bestTranscription.formattedString
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                }
                if partialResults {
                    log.info("onSpeechRecognitionPartialResult: \(lastString)")
                    self.onSpeechRecognitionPartialResult?(lastString)
                }
            }
            
            if isFinal {
                if !partialResults {
                    log.info("onSpeechRecognitionFinished: \(result!.bestTranscription.formattedString)")
                    self.onSpeechRecognitionFinished?(result!.bestTranscription.formattedString)
                    self.resetRecording()
                }
            } else {
                if error != nil {
                    self.resetRecording()
                }
           }
        }
            
        let recordingFormat = inputNode?.outputFormat(forBus: 0)
        
        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
            /// Taken from here: https://www.raywenderlich.com/5154-avaudioengine-tutorial-for-ios-getting-started
            guard let channelData = buffer.floatChannelData else { return }
            
            let channelDataValue = channelData.pointee
            let channelDataValueArray = stride(from: 0,
                                               to: Int(buffer.frameLength),
                                               by: buffer.stride).map{ channelDataValue[$0] }
       
            let rms = sqrt(channelDataValueArray.map{ $0 * $0 }.reduce(0, +)) / Float(buffer.frameLength)
            let avgPower = 20 * log10(rms)
            self.meterLevel = self.scaledPower(power: avgPower)
        }
        
        audioEngine?.prepare()
   
        do {
            try audioEngine?.start()
            log.info("recording started")
        } catch {
            log.error("audioEngine couldn't start because of an error")
        }
        
        startTimer()
        
        AudioServicesPlaySystemSound(1110)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    public func stopRecording(silent: Bool = false, success: Bool = true) {
        log.info("recording stopped")
        resetRecording()
        notify(silent: silent, success: success)
    }
    
    private func notify(silent: Bool = false, success: Bool = true) {
        if silent { return }
        if success {
            AudioServicesPlaySystemSound(1111)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            AudioServicesPlaySystemSound(1112)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
    
    private func resetRecording() {
        log.info("recording resetted")
        recordingTimer?.invalidate()
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        
        recognitionRequest = nil
        recognitionTask    = nil
        meterTimerCount    = 0
    }
    
    private func startTimer() {
        recordingTimer?.invalidate()
        recordingTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(onTimerExpired), userInfo: nil, repeats: true)
    }
    
    @objc
    private func onTimerExpired() {
        if meterLevel.isZero {
            meterTimerCount += 1
            if isRecording && meterTimerCount == 3 {
                stopRecording(success: notifySuccess)
                meterTimerCount = 0
            }
        } else {
            meterTimerCount = 0
        }
    }
    
    /// Taken from here: https://www.raywenderlich.com/5154-avaudioengine-tutorial-for-ios-getting-started
    private func scaledPower(power: Float) -> Float {
        guard power.isFinite else { return 0.0 }
        let minDb = Float(-80.0)

        if power < minDb {
            return 0.0
        } else if power >= 1.0 {
            return 1.0
        } else {
            return (abs(minDb) - abs(power)) / abs(minDb)
        }
    }
}
