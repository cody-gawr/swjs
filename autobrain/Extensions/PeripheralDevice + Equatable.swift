//
//  PeripheralDevice + Hashable.swift
//  autobrain
//
//  Created by hope on 11/13/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import Foundation
import RxBluetoothKit

extension ScannedPeripheral {
    
    public static func ==(lhs: ScannedPeripheral, rhs: ScannedPeripheral) -> Bool {
        return lhs.peripheral == rhs.peripheral
    }
}
