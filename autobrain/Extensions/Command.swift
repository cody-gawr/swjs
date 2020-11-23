//
//  Command.swift
//  autobrain
//
//  Created by hope on 11/18/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//
import Foundation
import RxBluetoothKit

struct Reply {
    
    var mode: String?
    var contents = [String]()
}

enum CommandType {
    case elm327(String)
    case obd2(String)
    case unsupported
}

extension CommandType {
    
    static func reply(from command: String) -> Reply {
        
        var result = [String]()
        var mode: String?
        var reply = Reply()
        
        switch command.commandType {
        case .elm327(let value):
            let items = value.components(separatedBy: String.CR)
            if items.count > 1 {
                result.append(items[1])
                mode = items[0]
            }
        case .obd2(let value):
            let items = value.components(separatedBy: " ")
            if items.count > 2 {
                result.append(contentsOf: items[2...])
                mode = items[0..<2].joined(separator: String.SPACE)
            }
        case .unsupported:
            break
        }
        
        reply.mode = mode
        reply.contents = result
        
        return reply
    }
    
    static func fetch(from items: [Reply]) -> Dictionary<String, Any> {
        var dict: Dictionary<String, Any> = [String: Any]()
        
        items.forEach {
            if let mode = $0.mode, let field = Constant.PID2FIELD[mode] {
                switch mode {
                case "41 0C":
                    if $0.contents.count > 1 {
                        let A = $0.contents[0].hexaToDecimal
                        let B = $0.contents[1].hexaToDecimal
                        dict[field] = (A * 256 + B) / 4
                    }
                case "49 02":
                    if $0.contents.count > 0 {
                        dict[field] = $0.contents[0]
                    }
                case "41 0D":
                    if $0.contents.count > 0 {
                        dict[field] = $0.contents[0].hexaToDecimal
                    }
                case "41 2F":
                    if $0.contents.count > 0 {
                        dict[field] = $0.contents[0].hexaToDecimal * 100 / 255
                    }
                case "41 A6":
                    if $0.contents.count > 3 {
                        let A = Int(truncating: NSDecimalNumber(decimal: pow(2, 24)))
                        let B = Int(truncating: NSDecimalNumber(decimal: pow(2, 16)))
                        let C = Int(truncating: NSDecimalNumber(decimal: pow(2, 8)))
                        dict[field] = $0.contents[0].hexaToDecimal * A + $0.contents[1].hexaToDecimal * B + $0.contents[2].hexaToDecimal * C + $0.contents[3].hexaToDecimal
                    }
                case "AT RV", "AT IGN":
                    if $0.contents.count > 0 {
                        dict[field] = $0.contents[0]
                    }
                default:
                    break
                }
            }
        }
        
        return dict
    }
    
    static func parameters(_ dict: Dictionary<String, Any>, with peripheral: Peripheral?) -> Dictionary<String, Any> {
        var dictionary = dict
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let location = DeviceLocation.shared.getDeviceLocation()
        
        dictionary["d"] = dateFormatter.string(from: date)
        dictionary["t"] = timeFormatter.string(from: date)
        if let lt = location?.latitude, let ln = location?.longitude {
            dictionary["lt"] = lt
            dictionary["ln"] = ln
        }
        dictionary["uid"] = peripheral?.identifier.uuidString
        
        return dictionary
    }
    
    func message(_ dict: Dictionary<String, Any>) -> Message? {
        var message: Message?
        
        do {
            message = try Message(from: dict) { decoder in
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            }
            
        } catch {
            print("Error: \(error)")
        }
        
        return message
    }
}
