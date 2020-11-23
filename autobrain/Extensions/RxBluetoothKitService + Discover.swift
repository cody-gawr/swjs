//
//  RxBluetoothKitService + Discover.swift
//  autobrain
//
//  Created by hope on 11/13/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxSwift
import RxBluetoothKit

extension RxBluetoothKitService {
    
    public func filter(for scannedPeripherals: [ScannedPeripheral]) -> Peripheral? {
        var corePeripheral: Peripheral?
        if let firstIndex = scannedPeripherals.firstIndex(where: { $0.peripheral.name?.lowercased().contains(Constant.PERIPHERAL_NAME.lowercased()) ?? false }) {
            corePeripheral = scannedPeripherals[firstIndex].peripheral
        }
        
        return corePeripheral
    }
}

enum BluetoothServiceError: Error {
    case unknown(Error)
    case notFound
}
