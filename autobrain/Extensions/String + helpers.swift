//
//  String + HexString.swift
//  autobrain
//
//  Created by hope on 11/16/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import Foundation
import CoreBluetooth

extension String {
    
    static func hexString(from: [Int]) -> String {
        
        return from.map { String(format: "%02X", $0) }
            .reduce("", { $0 + $1 })
    }
    
    static var CR: String {
        return String(Character(UnicodeScalar(0x0D)!))
    }
    
    static var SPACE: String {
        return " "
    }
    
    var isReply: Bool {
        return self.components(separatedBy: Self.CR).count > 2
    }
    
    var replyComponent: String? {
        var _reply: String?
        if isReply {
            switch self.commandType {
            case .elm327, .unsupported:
                _reply = self
            case .obd2:
                _reply = self.components(separatedBy: Self.CR)[0]
            }
        }
        
        return _reply
    }
    
    var hexaToDecimal: Int {
        return Int(strtoul(self, nil, 16))
    }
    
    var isOBD2: Bool {
        let firstComponent = self.components(separatedBy: " ")[0]
        return firstComponent.hexaToDecimal > 0x40
    }
    
    var isELM327: Bool {
        return self.contains("AT")
    }
    
    var commandType: CommandType {
        if self.isELM327 {
            return .elm327(self)
        } else if self.isOBD2 {
            return .obd2(self)
        }
        return .unsupported
    }
}
