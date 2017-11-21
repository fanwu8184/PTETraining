//
//  DICollection.swift
//  PTETraining
//
//  Created by Fan Wu on 4/17/17.
//  Copyright © 2017 8184. All rights reserved.
//

import UIKit

private let imageCell = "imageCell"
private let diSegue = "diSegue"

class DICVC: UICollectionViewController {
    private var data = [DIPractices]()

    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHud.processing(to: view)
        dbService.fetchSpeakingDIPractices { (json) in
            ProgressHud.hideProcessing(to: self.view)
            self.data = json.arrayValue.map({ DIPractices($0) })
            self.collectionView?.reloadData()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let speakingBVC = segue.destination as? DIVC {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCell, for: indexPath)
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let imageCell = cell as! ImageCCell
        imageCell.imageURLString = data[indexPath.item].imageURL
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: diSegue, sender: indexPath)
    }
}
