//
//  RAPractices.swift
//  PTETraining
//
//  Created by Fan Wu on 6/22/17.
//  Copyright © 2017 8184. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RAPractices {
    var raText: String
    
    init(_ json: JSON) {
        raText = json["RAText"].stringValue
    }
}
