//
//  DICell2.swift
//  PTETraining
//
//  Created by Fan Wu on 4/20/17.
//  Copyright © 2017 8184. All rights reserved.
//

import UIKit

private let animationTime = 0.5

class DICCell: ImageCCell, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 2
        scrollView.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
