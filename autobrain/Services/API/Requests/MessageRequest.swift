//
//  MessageRequest.swift
//  autobrain
//
//  Created by hope on 11/19/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import Foundation

struct MessageRequest: APIRequest {
    
    var method: RequestType = .POST
    var path: String = "api/handle_bluetooth_webhook"
    var parameters: [String : Any]
}
