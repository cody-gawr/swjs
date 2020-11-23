//
//  MessageBuilder.swift
//  autobrain
//
//  Created by Kyle Smith on 11/16/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import Foundation
import RxBluetoothKit


class MessageBuilder {
    private var characteristic: Characteristic
    private let rxBluetoothKitService: RxBluetoothKitService
    private let deviceLocation: DeviceLocation
    public var message: Message = Message.emptyMessage
    let api = APIClient()

    var ignitionState = "OFF"
    var voltage = 0.0
    var peripheralUid = ""
    var speed: String?
    var rpm: String?
    var fuelLevel: String?
    var vin: String?
    var mileage: String?
    
    enum MessageType: String {
        case ignition = "AT IGN\r"
        case voltage = "AT RV\r"
        case dtcCodesCount = "01 01"
        case dtcCodes = "01 03"
        case resetDtcs = "01 04"
        case speed = "01 0D\r"
        case rpm = "01 0C\r"
        case fuelLevel = "01 2F\r"
        case vin = "09 02\r"
        case mileage = "01 A6\r"
    }
    
    var lastMessageTypeSent: MessageType?
    
    init(characteristic: Characteristic, rxBluetoothKitService: RxBluetoothKitService, peripheralUid: String) {
        self.characteristic = characteristic
        self.rxBluetoothKitService = rxBluetoothKitService
        self.message.uid = peripheralUid
        self.deviceLocation = DeviceLocation()
        callMyFunction()
    }
    
    func callMyFunction() {
        var messagesToCall: [MessageType] = [MessageType.speed,
                                             MessageType.rpm,
                                             MessageType.fuelLevel,
                                             MessageType.vin,
                                             MessageType.mileage,
                                             MessageType.voltage,
                                             MessageType.ignition]
        characteristic.observeValueUpdate().subscribe(onNext: {
            switch self.lastMessageTypeSent {
            case .ignition:
                self.message.ig = self.parsedResponse(value: $0.value!) == "ON" ? 1 : 0
                self.message.ev =  self.parsedResponse(value: $0.value!) == "ON" ? 62 : 61
            case .voltage:
                self.message.bv = Double(self.parsedResponse(value: $0.value!).dropLast()) ?? 0
            case .mileage:
                var ans = String(decoding: $0.value!, as: UTF8.self)
                self.message.od = String(decoding: $0.value!, as: UTF8.self)
            case .speed:
                self.message.sp = String(decoding: $0.value!, as: UTF8.self)
            case .rpm:
                self.message.rpm = String(decoding: $0.value!, as: UTF8.self)
            case .fuelLevel:
                self.message.fl = String(decoding: $0.value!, as: UTF8.self)
            case .vin:
                self.message.vn = String(decoding: $0.value!, as: UTF8.self)
            default:
                print("we did it")
            }
            self.sendNextMessage(messagesToCall: &messagesToCall)
        }, onError: { (error) in
            print(error.localizedDescription)
        } ,onCompleted: {
            print("onCompleted")
        } ,onDisposed: {
            print("onDisposed")
        })

        sendNextMessage(messagesToCall: &messagesToCall)
    }
    
    func sendNextMessage(messagesToCall: inout [MessageType]) {
        if messagesToCall.isEmpty {
            buildMessage(uid: peripheralUid)
        } else {
            self.lastMessageTypeSent = messagesToCall.popLast() ?? nil
            guard let message = lastMessageTypeSent?.rawValue else { return }
            writeToCharacteristic(data: Data(Array(message.utf8)))
        }
    }
    
    private func buildMessage(uid: String) {
        let location = deviceLocation.getDeviceLocation()
        message.lt = location?.latitude
        message.ln = location?.longitude
        sendMessage()
    }
    
    private func sendMessage() {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(message)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        api.sendMessage(params: ["data": json], success: { (success) in
            print(success)
        }, failure: { (failure) in
            print(failure.localizedDescription)
        })
    }
    
    enum BluetoothError: Error {
        case parsing
    }
    
    private func parsedResponse(value: Data) -> String {
        let response = String(decoding: value, as: UTF8.self)
        let lines = response.components(separatedBy: "\r")
        return lines[1]
    }
    
    private func writeToCharacteristic(data: Data) {
        rxBluetoothKitService.writeValueTo(characteristic: characteristic, data: data)
    }
}
