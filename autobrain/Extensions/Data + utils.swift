//
//  Data + utils.swift
//  autobrain
//
//  Created by hope on 11/12/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import Foundation

extension Data {
    
    // Return Data represented by this hexadecimal string
    static func fromHexString(string: String) -> Data {
        var data = Data(capacity: string.count / 2)
        
        let regex = try? NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex?.enumerateMatches(in: string, options: [], range: NSMakeRange(0, string.count)) { match, _, _ in
            if let match = match {
                let byteString = (string as NSString).substring(with: match.range)
                if var num  = UInt8(byteString, radix: 16) {
                    data.append(&num, count: 1)
                }
            }
        }
        
        return data
    }
}
