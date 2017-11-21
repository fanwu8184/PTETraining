//
//  RL.swift
//  PTETraining
//
//  Created by Fan Wu on 6/11/17.
//  Copyright © 2017 8184. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RLPractices {
    var audioTopic: String
    var audioText: String
    var audioURL: String
    
    init(_ json: JSON) {
        audioTopic = json["AudioTopic"].stringValue
        audioText = json["AudioText"].stringValue
        audioURL = json["AudioURL"].stringValue
    }
}
