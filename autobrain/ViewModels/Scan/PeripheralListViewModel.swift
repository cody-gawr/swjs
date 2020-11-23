//
//  PeripheralListViewModel.swift
//  autobrain
//
//  Created by hope on 11/13/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxBluetoothKit

class PeripheralListViewModel {
    
    public var characteristic: Characteristic?
    
    public var peripheral: Peripheral?
    
    public let rxBluetoothKitService: RxBluetoothKitService
    
    public let peripheralRowItemsSubject: PublishSubject<[ScannedPeripheral]> = PublishSubject()
    
    public let peripheralSubject: PublishSubject<Peripheral> = PublishSubject()
    
    public let characteristicSubject: PublishSubject<Characteristic> = PublishSubject()
    
    let buttonClickedSubject = PublishSubject<ScannedPeripheral>()
    
    public let clickSubject: PublishSubject<Void> = PublishSubject()
    
    public var repliesSubject = PublishSubject<[String]>()
    
    private let timeoutSubject: PublishSubject<Error> = PublishSubject()
    
    public let characteristicErrorSubject: PublishSubject<Error> = PublishSubject()
    
    private var characteristicDisposable: Disposable?
    
    private var timeMannerDisposable: Disposable?
    
    private var didFindCharacteristic: Bool = false
    
    public var peripherals: [ScannedPeripheral] = []
    
    private var replies: [String] = []
    
    public var isScanning: Bool = false
    
    private let disposeBag = DisposeBag()
    
    public var disconnectionOutput: Observable<Result<RxBluetoothKitService.Disconnection, Error>> {
        return rxBluetoothKitService.disconnectionReasonOutput
    }
    
    var characteristicReadOutput: Observable<Result<Characteristic, Error>> {
        return rxBluetoothKitService.readValueOutput
    }
    
    var characteristicWriteOutput: Observable<Result<Characteristic, Error>> {
        return rxBluetoothKitService.writeValueOutput
    }
    
    var updatedValueAndNotificationOutput: Observable<Result<Characteristic, Error>> {
        return rxBluetoothKitService.updatedValueAndNotificationOutput
    }
    
    public var allCommands: [String] {
        return Array(Constant.COMMAND_DICTIONARY.values)
            .map { $0 + String.CR }
    }
    
    init (_ service: RxBluetoothKitService) {
        rxBluetoothKitService = service
        bindSubscriptions()
    }
    
    func append(_ item: ScannedPeripheral) {
        let identicalPeripheral = peripherals.filter {
            $0 == item
        }
        
        guard identicalPeripheral.isEmpty else {
            return
        }
        
        peripherals.append(item)
        peripheralRowItemsSubject.onNext(peripherals)
    }
    
    func append(_ item: String) {
        let identicalResponse = replies.filter {
            $0 == item
        }
        
        guard identicalResponse.isEmpty else {
            return
        }
        
        replies.append(item)
        if replies.count == Constant.COMMAND_DICTIONARY.count {
            repliesSubject.onNext(replies)
            replies = []
        }
    }
    
    func scanAction() {
        self.peripherals = []
        self.didFindCharacteristic = false
        if isScanning {
            rxBluetoothKitService.stopScanning()
            if let peripheral = self.peripheral {
                rxBluetoothKitService.disconnect(peripheral)
                self.peripheral = nil
            }
            characteristicDisposable?.dispose()
            timeMannerDisposable?.dispose()
        } else {
            rxBluetoothKitService.startScanning(withServices: [Constant.SERVICE_UUID])
        }
        self.isScanning = !self.isScanning
    }
    
    //MARK: -Methods
    private func subscribeForNotifications() {
        guard let characteristic = self.characteristic, let peripheral = self.peripheral else {
            return
        }
        rxBluetoothKitService.observeValueUpdateAndSetNotification(for: characteristic)
        rxBluetoothKitService.observeNotifyValue(peripheral: peripheral, characteristic: characteristic)
    }
    
    private func writeToCharacteristic(data: Data) {
        guard let characteristic = self.characteristic else {
            return
        }
        rxBluetoothKitService.writeValueTo(characteristic: characteristic, data: data)
    }
    
    private func bindScannedPeripheralObserver(to observable: Observable<Result<ScannedPeripheral, Error>>) {
        observable.subscribe(onNext: { [unowned self] result in
            switch result {
            case .success(let value):
                self.append(value)
            case .error(let error):
                self.timeoutSubject.onNext(error)
                break
            }
        }, onError: {
            self.timeoutSubject.onNext($0)
        }).disposed(by: disposeBag)
    }
    
    private func bindSubscriptions() {
        self.clickSubject
            .subscribe(onNext: { [unowned self] in
                self.scanAction()
            })
            .disposed(by: disposeBag)
        
        bindScannedPeripheralObserver(to: self.rxBluetoothKitService.scanningOutput)
        subscribeCharacteristicOutput(self.characteristicReadOutput)
        subscribeCharacteristicOutput(self.updatedValueAndNotificationOutput)
        subscribeCharacteristicWriteOutput(self.characteristicWriteOutput)
        
        self.timeoutSubject
            .flatMap { [weak self] _ -> Observable<Peripheral> in
                guard let `self` = self, let peripheral = self.rxBluetoothKitService.filter(for: self.peripherals) else {
                    return Observable.empty()
                }
                return Observable.just(peripheral)
            }
            .subscribe(onNext: { [unowned self] in
                self.peripheral = $0
                self.rxBluetoothKitService.discoverCharacteristics(for: $0, withServices: [Constant.SERVICE_UUID], withCharacteristics: [Constant.CHARACTERISTIC_UUID])
            })
            .disposed(by: disposeBag)
        
        rxBluetoothKitService.discoveredCharacteristicsOutput
            .subscribe(onNext: { [unowned self] result in
                switch(result) {
                case .success(let characteristics):
                    self.characteristic = characteristics.filter { $0.uuid == Constant.CHARACTERISTIC_UUID }.first
                    if let characteristic = self.characteristic {
                        self.characteristicSubject.onNext(characteristic)
                        self.subscribeForNotifications()
                        print("Find a Characteristic \(characteristic)" )
                    }
                case .error(let error):
                    self.characteristicErrorSubject.onNext(error)
                }
            })
            .disposed(by: disposeBag)
        
        let timer = Observable<NSInteger>.interval(.seconds(Constant.POLL_INTERVAL), scheduler: MainScheduler.instance)
        
        timeMannerDisposable = Observable.combineLatest(characteristicSubject.asObservable(),
                                                        timer,
                                                        resultSelector: { (characteristic, _) -> Characteristic in characteristic })
                    .flatMap { [weak self] _ -> Observable<String> in
                        guard let self = self else {
                            return Observable.empty()
                        }
                        return self.observeCommands()
                    }.subscribe(onNext: {
                        print("Write a command \($0)")
                        self.writeToCharacteristic(data: $0.data(using: .ascii)!)
                    })
            
    }
    
    private func observeCommands() -> Observable<String> {
        let timer = Observable<NSInteger>.interval(.milliseconds(600), scheduler: MainScheduler.instance)
        
        let commands = Observable.from(allCommands)
            
        return Observable.zip(commands,
                              timer,
                              resultSelector: { (command, _) -> String in command })
    }
    
    private func subscribeCharacteristicOutput(_ outputStream: Observable<Result<Characteristic, Error>>) {
        outputStream.subscribe(onNext: { [unowned self] result in
            var updatedValue: String?
            switch result {
            case .success(let characteristic):
                guard let value = characteristic.value else { return }
                updatedValue = String(decoding: value, as: UTF8.self)
            case .error(let error):
                print("Read Error: \(error.localizedDescription)")
            }
            guard let _updatedValue = updatedValue, let reply = _updatedValue.replyComponent else { return }
            self.append(reply)
        })
        .disposed(by: disposeBag)
    }
    
    private func subscribeCharacteristicWriteOutput(_ writeOutputStream: Observable<Result<Characteristic, Error>>) {
        writeOutputStream.subscribe(onNext: { result in
            switch result {
            case .success(let characteristic):
                guard let value = characteristic.value else { return }
                print("Callback for writing a command \(String(decoding: value, as: UTF8.self))")
            case .error(let error):
                print("Read Error: \(error.localizedDescription)")
            }
        })
        .disposed(by: disposeBag)
    }
}
