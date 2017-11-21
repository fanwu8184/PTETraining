//
//  DI.swift
//  PTETraining
//
//  Created by Fan Wu on 6/11/17.
//  Copyright © 2017 8184. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DIPractices {
    var imageURL: String
    
    init(_ json: JSON) {
        imageURL = json["ImageURL"].stringValue
    }
}
