//
//  FWPlayer.swift
//  PTETraining
//
//  Created by Fan Wu on 5/13/17.
//  Copyright © 2017 8184. All rights reserved.
//

import Foundation
import AVFoundation
import Alamofire

private let playerError = "Sorry, you might didn't record anything yet, or there is something wrong with the player."
private let downloadError = "Sorry, fail to download the audio data."

class FWPlayer {
    private var audioPlayer: AVAudioPlayer?
    var isPlaying: Bool { return audioPlayer?.isPlaying ?? false }
    var duration: TimeInterval { return audioPlayer?.duration ?? 0 }
    var currentTime: TimeInterval {
        set { audioPlayer?.currentTime = newValue }
        get { return audioPlayer?.currentTime ?? 0 }
    }
    
    func play(audioFileURL: URL, afterSetup: ((AVAudioPlayer?, String?) -> Void)?) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try audioPlayer = AVAudioPlayer(contentsOf: audioFileURL)
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            audioPlayer?.play()
            afterSetup?(audioPlayer, nil)
        } catch {
            afterSetup?(nil, playerError)
        }
    }
    
    func play(url: URLConvertible, afterSetup: ((AVAudioPlayer?, String?) -> Void)?) {
        Alamofire.request(url).responseData { response in
            if let data = response.result.value {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
                    try self.audioPlayer = AVAudioPlayer(data: data)
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
                    self.audioPlayer?.play()
                    afterSetup?(self.audioPlayer, nil)
                } catch {
                    afterSetup?(nil, playerError)
                }
            }
            else {
                afterSetup?(nil, downloadError)
            }
        }
    }
    
    func stop() {
        audioPlayer?.stop()
    }
}
