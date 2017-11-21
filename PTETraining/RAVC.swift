//
//  RAVC.swift
//  PTETraining
//
//  Created by Fan Wu on 6/22/17.
//  Copyright © 2017 8184. All rights reserved.
//

import UIKit

private let labelCell = "labelCell"

class RAVC: SpeakingBVC {
    override var timeToPrepare: Float { return 35 }
    override var timeToRecord: Float { return 35 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: labelCell, for: indexPath)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let practices = data as? [RAPractices] {
            let labelCell = cell as! LabelCCell
            labelCell.label.text = practices[indexPath.item].raText
        }
    }
    
    // MARK: WebView
    override func getWebFileURL(completion: @escaping (URL?, String?) -> Void) {
        dbService.fetchSpeakingRATipsURL { (url, error) in
            completion(url, error)
        }
    }
}
