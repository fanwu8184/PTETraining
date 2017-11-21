//
//  FWSpeech.swift
//  PTETraining
//
//  Created by Fan Wu on 5/13/17.
//  Copyright © 2017 8184. All rights reserved.
//

import Foundation
import Speech

private let finalResultUDK = "finalResult"

class FWSpeech {
    private let speechRecognizer = SFSpeechRecognizer()
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    var isAvailable: Bool { return speechRecognizer?.isAvailable ?? false }
    var isTaskRunning = false
    var finalResult: String? {
        get { return UserDefaults.standard.object(forKey: finalResultUDK) as? String }
        set { UserDefaults.standard.set(newValue, forKey: finalResultUDK) }
    }
    
    func requestPermission(completion: @escaping (SFSpeechRecognizerAuthorizationStatus) -> Void) {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            completion(authStatus)
        }
    }
    
    func transcribe(audioFileURL: URL, completion: @escaping (String?, String?) -> Void) {
        isTaskRunning = true
        let request = SFSpeechURLRecognitionRequest(url: audioFileURL)
        speechRecognitionTask = speechRecognizer?.recognitionTask(with: request) { (result, error) in
            if let err = error {
                self.isTaskRunning = false
                completion(nil, err.localizedDescription)
            } else {
                completion(result?.bestTranscription.formattedString, nil)
                if result?.isFinal == true {
                    self.finalResult = result?.bestTranscription.formattedString
                    self.isTaskRunning = false
                }
            }
        }
    }
}
