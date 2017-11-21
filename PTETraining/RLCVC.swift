//
//  RLCVC.swift
//  PTETraining
//
//  Created by Fan Wu on 6/11/17.
//  Copyright © 2017 8184. All rights reserved.
//

import UIKit

private let labelCell = "labelCell"
private let rlSegue = "rlSegue"

class RLCVC: UICollectionViewController {
    private var data = [RLPractices]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHud.processing(to: view)
        dbService.fetchSpeakingRLPractices { (json) in
            ProgressHud.hideProcessing(to: self.view)
            self.data = json.arrayValue.map({ RLPractices($0) })
            self.collectionView?.reloadData()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let speakingBVC = segue.destination as? RLVC {
            speakingBVC.data = data
            speakingBVC.currentPage = sender as? IndexPath
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: labelCell, for: indexPath)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let labelCell = cell as! LabelCCell
        labelCell.label.text = "\(indexPath.item + 1)"
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: rlSegue, sender: indexPath)
    }
}
