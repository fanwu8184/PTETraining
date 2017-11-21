//
//  RSVC.swift
//  PTETraining
//
//  Created by Fan Wu on 6/30/17.
//  Copyright © 2017 8184. All rights reserved.
//

import UIKit
import AVFoundation

private let labelCell = "labelCell"

class RSVC: SpeakingBVC {
    override var timeToPrepare: Float { return 3 }
    override var timeToRecord: Float { return 15 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func timing() {
        if timer.isRunning {
            stopTimer()
        } else {
            guard let indexPath = currentPage else { return }
            if let practices = data as? [RSPractices] {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: labelCell, for: indexPath)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let practices = data as? [RSPractices] {
            let labelCell = cell as! LabelCCell
            labelCell.content = practices[indexPath.item].audioText
        }
    }
    
    // MARK: Player
    override func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        super.audioPlayerDidFinishPlaying(player, successfully: flag)
        if isPlayingPractice {
            record()
            isPlayingPractice = false
        }
    }
    
    // MARK: WebView
    override func getWebFileURL(completion: @escaping (URL?, String?) -> Void) {
        dbService.fetchSpeakingRSTipsURL { (url, error) in
            completion(url, error)
        }
    }
}
