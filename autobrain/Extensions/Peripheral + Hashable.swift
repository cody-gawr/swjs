//
//  Peripheral + Hashable.swift
//  autobrain
//
//  Created by hope on 11/12/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import Foundation
import RxBluetoothKit

extension Peripheral: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        let scalarArray: [UInt32] = []
        hasher.combine(scalarArray.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        })
    }
}
