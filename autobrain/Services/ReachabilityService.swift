//
//  ReachabilityService.swift
//  Autobrain
//
//  Created by Kyle Smith on 10/17/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityService: NSObject {
    
    override init() {
        super.init()
    }
    
    static func checkReachability() -> Bool {
        let reachability = Reachability()!
        
        switch reachability.connection {
        case .wifi, .cellular:
            return true
        case .none:
            return false
        }
    }
}
