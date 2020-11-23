//
//  Message.swift
//  autobrain
//
//  Created by Kyle Smith on 11/16/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import Foundation

struct Message: Codable {
    var ev: Int         // event name
    var ig: Int?         // ignition state
    var uid: String     // identifier of the device
    var lt: Double?      // current latitude of the device
    var ln: Double?      // current longitude of the device
    var bv: Double      // battery voltage
    var od: String?      // odometer reading
    var d: Date         // date the message was built
    var t: String       // time the message was built
    var sp: String?      // speed of the car
    var rpm: String?        // rpm of the car
    var vn: String?      // vin of the car
    var fl: String?      // fuel level of the car
}
 
extension Message {
    static var emptyMessage: Message {
        Message(ev: 0, uid: "", bv: 0, d: .init(), t: "")
    }
}
