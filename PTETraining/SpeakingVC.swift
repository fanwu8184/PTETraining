//
//  SpeakingVC.swift
//  PTETraining
//
//  Created by Fan Wu on 6/29/17.
//  Copyright © 2017 8184. All rights reserved.
//

import UIKit

private let cacheMemoryCapacityM = 50

class SpeakingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        cache()
    }
    
    // MARK: Cache
    private func cache() {
        let memoryCapacity = cacheMemoryCapacityM * 1024 * 1024
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: memoryCapacity, diskPath: nil)
        URLCache.shared = urlCache
    }
}
