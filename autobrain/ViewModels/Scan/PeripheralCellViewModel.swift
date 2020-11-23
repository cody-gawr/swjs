//
//  PeripheralViewModel.swift
//  autobrain
//
//  Created by hope on 11/14/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import Foundation
import RxBluetoothKit
import RxSwift

final class PeripheralCellViewModel {
    
    private(set) var peripheral: ScannedPeripheral
    
    init(_ peripheral: ScannedPeripheral) {
        self.peripheral = peripheral
    }
}
