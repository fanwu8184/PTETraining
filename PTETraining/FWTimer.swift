//
//  File.swift
//  PTETraining
//
//  Created by Fan Wu on 5/10/17.
//  Copyright © 2017 8184. All rights reserved.
//

import Foundation
import AVFoundation

private let soundID = 1070 //check it on web: http://iphonedevwiki.net/index.php/AudioServices

class FWTimer {
    private var timer = Timer()
    var isRunning: Bool { return timer.isValid }
    
    func activate(seconds: Float? = nil, intervalTime: TimeInterval, action: ((Float) -> Void)?, completion: (() -> Void)? = nil) {
        var countTime: Float = seconds ?? 0
        timer = Timer.scheduledTimer(withTimeInterval: intervalTime, repeats: true) { (_) in
            action?(countTime)
            if seconds != nil {
                countTime -= Float(intervalTime)
                if countTime <= 0 {
                    AudioServicesPlaySystemSound(SystemSoundID(soundID))
                    self.stop { completion?() }
                }
            }
        }
    }
    
    func stop(completion: (() -> Void)? = nil) {
        timer.invalidate()
        completion?()
    }
}
