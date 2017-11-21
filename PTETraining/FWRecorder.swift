//
//  FWRecorder.swift
//  PTETraining
//
//  Created by Fan Wu on 5/13/17.
//  Copyright © 2017 8184. All rights reserved.
//

import Foundation
import AVFoundation

private let recorderError = "Sorry, there is something wrong during setting up the recorder."

class FWRecorder {
    private var audioRecorder: AVAudioRecorder?
    var isRecording: Bool { return audioRecorder?.isRecording ?? false }
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { (allowed) in
            completion(allowed)
        }
    }
    
    func record(audioFileURL: URL, afterSetup: ((AVAudioRecorder?, String?) -> Void)?) {
        let audioSettings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try audioRecorder = AVAudioRecorder(url: audioFileURL, settings: audioSettings)
            audioRecorder?.record()
            afterSetup?(audioRecorder, nil)
        } catch {
            afterSetup?(nil, recorderError)
        }
    }
    
    func stop() {
        audioRecorder?.stop()
    }
    
    func enableMeters() {
        audioRecorder?.isMeteringEnabled = true
    }
    
    func updateMeters() {
        audioRecorder?.updateMeters()
    }
    
    func averagePower(channel: Int) -> Float? {
        return audioRecorder?.averagePower(forChannel: channel)
    }
}
