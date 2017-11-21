//
//  RLVC.swift
//  PTETraining
//
//  Created by Fan Wu on 6/1/17.
//  Copyright © 2017 8184. All rights reserved.
//

import UIKit
import AVFoundation

private let rlCell = "rlCell"

class RLVC: SpeakingBVC {
    override var timeToPrepare: Float { return 3 }
    var timeBeforeRecord: Float { return 10 }
    override var timeToRecord: Float { return 40 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func timing() {
        if timer.isRunning {
            stopTimer()
        } else {
            guard let indexPath = currentPage else { return }
            if let practices = data as? [RLPractices] {
                let urlString = practices[indexPath.item].audioURL
                startTimer(timeToPrepare) {
                    self.playPractice(urlString)
                    self.isPlayingPractice = true
                }
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rlCell, for: indexPath)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let practices = data as? [RLPractices] {
            let rlCell = cell as! RLCCell
            rlCell.rlTopicLabel.text = practices[indexPath.item].audioTopic
            rlCell.content = practices[indexPath.item].audioText
        }
    }
    
    // MARK: Player
    override func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        super.audioPlayerDidFinishPlaying(player, successfully: flag)
        if isPlayingPractice {
            startTimer(timeBeforeRecord) { self.record() }
            isPlayingPractice = false
        }
    }
    
    // MARK: WebView
    override func getWebFileURL(completion: @escaping (URL?, String?) -> Void) {
        dbService.fetchSpeakingRLTipsURL { (url, error) in
            completion(url, error)
        }
    }
}
