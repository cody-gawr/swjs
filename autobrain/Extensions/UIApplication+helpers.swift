//
//  UIApplication+helpers.swift
//  Autobrain
//
//  Created by Kyle Smith on 8/2/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
