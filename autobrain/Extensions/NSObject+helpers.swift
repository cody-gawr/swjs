//
//  NSObject+helpers.swift
//  autobrain
//
//  Created by Kyle Smith on 9/11/18.
//  Copyright © 2018 SWJG-Ventures, LLC. All rights reserved.
//
import UIKit

extension NSObject {
    func openUrl(urlString: String) {
        if let url = URL(string: urlString),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.openURL(url)
        }
    }
}
