//
//  LabelCCellChild.swift
//  PTETraining
//
//  Created by Fan Wu on 6/30/17.
//  Copyright © 2017 8184. All rights reserved.
//

import UIKit

private let defaultText = "Tap to View Content..."

class LabelCCellChild: LabelCCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDefault()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
    }
    
    func tapAction() {
        if label.text == defaultText {
            setContent()
        } else {
            setDefault()
        }
    }
    
    private func setDefault() {
        label.text = defaultText
        label.textAlignment = .center
    }
    
    private func setContent() {
        label.text = content
        label.textAlignment = .left
    }
}
