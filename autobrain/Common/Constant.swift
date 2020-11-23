//
//  Constant.swift
//  autobrain
//
//  Created by hope on 11/12/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit
import CoreBluetooth

struct Constant {
    
    public static let APP_DEBUG = true
    public static let IS_ELM327 = false
    public static let SCANNING_TIME = 5
    public static let SCANNING_TIME_1 = 10
    public static let POLL_INTERVAL = 8
    public static var QUERY_INTERVAL = 300
//    public static var QUERY_INTERVAL: Int {
//        return POLL_INTERVAL / COMMAND_DICTIONARY.count
//    }
    public static var PERIPHERAL_NAME: String {
        if IS_ELM327 {
            return "Autobrain"
        } else {
            return "HMSoft"
        }
    }
    public static var SERVICE_UUID: CBUUID {
        if IS_ELM327 {
            return CBUUID(string: "FFF0")
        } else {
            return CBUUID(string: "FFE0")
        }
    }
    public static var CHARACTERISTIC_UUID: CBUUID {
        if IS_ELM327 {
            return CBUUID(string: "FFF1")
        } else {
            return CBUUID(string: "FFE1")
        }
    }
    
    public static let CR = 0x0D
    public static let COMMAND_DICTIONARY: Dictionary<String, String> = [
        "rpm"           : "01 0C", // Engine RPM
        "vin"           : "09 02",
        "speed"         : "01 0D",
        "fuel_level"    : "01 2F",
        "mileage"       : "01 A6",
        "ignition"      : "AT IGN",
        "voltage"       : "AT RV"
    ]
    
    public static let PID2FIELD: Dictionary<String, String> = [
        "41 0C"     : "rpm",
        "49 02"     : "vn",
        "41 0D"     : "sp",
        "41 2F"     : "fl",
        "41 A6"     : "od",
        "AT IGN"    : "ig",
        "AT RV"     : "bv"
    ]
    
    struct Strings {
        static let defaultDispatchQueueLabel = "com.autobrain.app.rxbluetoothkit.timer"
        static let unknown = "Unknown"
        static let success = "Success"
        static let error = "Error"
        static let warning = "Warning"
        static let defaultDisconnectionReason = "Disconnected by any reason."
    }
    
    struct UIColors {
        static let blue = UIColor(rgb: 0x00AAE8)
        static let white = UIColor(rgb: 0xFFFFFF)
        static let red = UIColor(rgb: 0xED5E68)
        static let background = UIColor(rgb: 0x000000)
        static let black = UIColor(rgb: 0xFF0000)
    }
    
    struct FontSize {
        static let small: CGFloat = 12.0
        static let medium: CGFloat = 14.0
        static let large: CGFloat = 17.0
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(rgb: Int) {
        if (rgb >> 24 > 0) {
            self.init(
                red: (rgb >> 24) & 0xFF,
                green: (rgb >> 16) & 0xFF,
                blue: (rgb >> 8) & 0xFF,
                alpha: CGFloat((rgb & 0xFF) / 0xFF)
            )
        }
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

