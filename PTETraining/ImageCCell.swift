//
//  imageCollectionViewCell.swift
//  PTETraining
//
//  Created by Fan Wu on 5/13/17.
//  Copyright © 2017 8184. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var imageURLString: String? {
        didSet {
            //set to default setting first to remove reused cell setting
            imageView.image = nil
            ProgressHud.hideProcessing(to: self)
            if let url = imageURLString {
                ProgressHud.processing(to: self)
                imageView.sd_setImage(with: URL(string: url)) { (image, err, SDImageCacheType, url) in
                    ProgressHud.hideProcessing(to: self)
                }
            }
        }
    }
}
