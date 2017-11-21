//
//  ASQPractices.swift
//  PTETraining
//
//  Created by Fan Wu on 6/29/17.
//  Copyright © 2017 8184. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ASQPractices {
    var audioText: String
    var audioURL: String
    
    init(_ json: JSON) {
        audioText = json["AudioText"].stringValue
        audioURL = json["AudioURL"].stringValue
    }
}
