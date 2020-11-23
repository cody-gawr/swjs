//
//  Message.swift
//  autobrain
//
//  Created by hope on 11/19/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import Foundation

struct Response: Codable {
    
    var success: Bool
    var data: String
    var errors: [[String: String]]
}
