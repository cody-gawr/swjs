//
//  CustomView.swift
//  autobrain
//
//  Created by hope on 11/13/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit

protocol CustomView {
    
    associatedtype ViewClass: UIView
    
    var customView: ViewClass { get }
}

extension CustomView where Self: UIViewController {
    var customView: ViewClass {
        guard let customView = self.view as? ViewClass else {
            fatalError("Couldn't cast. Type incompatibility \(#file):\(#line)")
        }
        return customView
    }
}
