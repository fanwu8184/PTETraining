//
//  DIVC.swift
//  PTETraining
//
//  Created by Fan Wu on 5/13/17.
//  Copyright © 2017 8184. All rights reserved.
//

import UIKit
//import AVFoundation
//import Speech

private let diCell = "diCell"

class DIVC: SpeakingBVC {
    override var timeToPrepare: Float { return 25 }
    override var timeToRecord: Float { return 40 }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: diCell, for: indexPath)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let practices = data as? [DIPractices] {
            let diCell = cell as! DICCell
            diCell.imageURLString = practices[indexPath.item].imageURL
        }
    }
    
    override func updateCellWhenScroll() {
        guard let indexPath = currentPage else { return }
        let diCell = speakingCollectionView.cellForItem(at: indexPath) as! DICCell
        diCell.scrollView.setZoomScale(1, animated: true)
    }
    
    // MARK: WebView
    override func getWebFileURL(completion: @escaping (URL?, String?) -> Void) {
        dbService.fetchSpeakingDITipsURL { (url, error) in
            completion(url, error)
        }
    }
}
