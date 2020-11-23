//
//  Session.swift
//  autobrain
//
//  Created by Vedran Ozir on 12/03/16.
//  Copyright © 2016 Vedran Ozir. All rights reserved.
//

import Foundation
import CoreLocation

final class Session {
    
    static fileprivate var sessionCurrent = Session()
    
    internal var push_token: String?
    var viewController: MainViewController?
    
    class func current() -> Session {
        return sessionCurrent
    }
    
    class internal func setCurrent(_ session: Session) {
        sessionCurrent = session
    }
    
    class func performAsync( _ action: @escaping (() -> Void)) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: {
            action()
        })
    }
    
    class func performSync( _ action: @escaping (() -> Void)) {
        DispatchQueue.main.async(execute: {
            action()
        })
    }
}
