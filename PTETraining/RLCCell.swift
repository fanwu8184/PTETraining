//
//  RLCCell.swift
//  PTETraining
//
//  Created by Fan Wu on 6/13/17.
//  Copyright © 2017 8184. All rights reserved.
//

import UIKit

private let defaultText = "Tap to View Content..."

class RLCCell: UICollectionViewCell {
    @IBOutlet weak var rlTopicLabel: UILabel!
    @IBOutlet weak var rlContentTextView: UITextView!
    var content: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDefault()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        rlContentTextView.addGestureRecognizer(tap)
    }
    
    func tapAction() {
        if rlContentTextView.text == defaultText {
            setContent()
        } else {
            setDefault()
        }
    }
    
    private func setDefault() {
        rlTopicLabel.alpha = 0
        rlContentTextView.text = defaultText
    }
    
    private func setContent() {
        rlTopicLabel.alpha = 1
        rlContentTextView.text = content
    }
}
