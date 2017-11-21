//
//  FBCVC.swift
//  PTETraining
//
//  Created by Fan Wu on 7/10/17.
//  Copyright © 2017 8184. All rights reserved.
//

import UIKit

private let labelCell = "labelCell"

class FBCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let myText = "British commanders had **indeed learnt the lessons of the Crimean War, and could adapt themselves to battalion and regimental columns maneuvering in jungles, deserts and mountainous regions; what they failed to _______ was that when they came up against the Boers all their tactical and technical skills were of little use because they had _____ failed to comprehend the trench fighting and _____ raids of the American Civil War. In 1899 all arms of the British service went to war with what was to _____ antiquated tactics, and in some cases antiquated weapons."
    private var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = myText.components(separatedBy: " ")
        collectionView?.reloadData()
//        ProgressHud.processing(to: view)
//        dbService.fetchSpeakingDIPractices { (json) in
//            ProgressHud.hideProcessing(to: self.view)
//            self.data = json.arrayValue.map({ DIPractices($0) })
//            self.collectionView?.reloadData()
//        }
    }
    
    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let speakingBVC = segue.destination as? DIVC {
//            speakingBVC.data = data
//            speakingBVC.currentPage = sender as? IndexPath
//        }
//    }
    
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
        labelCell.label.text = data[indexPath.item]
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        performSegue(withIdentifier: diSegue, sender: indexPath)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let stringWidth = data[indexPath.item].width(withConstraintedHeight: 30, font: UIFont.systemFont(ofSize: 11))
        let cellWidth = stringWidth + 2
        return CGSize(width: cellWidth, height: 30)
    }
}
