//
//  PeripheralLiistViewController.swift
//  autobrain
//
//  Created by hope on 11/13/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxBluetoothKit

class PeripheralListViewController: UIViewController, CustomView {
    
    typealias ViewClass = PeripheralListView
    
    private let rxBluetoothKitService: RxBluetoothKitService
    
    private let viewModel: PeripheralListViewModel
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = ViewClass()
    }
    
    init(_ rxBluetoothKitService: RxBluetoothKitService) {
        self.rxBluetoothKitService = rxBluetoothKitService
        self.viewModel = PeripheralListViewModel(self.rxBluetoothKitService)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        testFunc()
    }

    private func setupBindings() {
        
        viewModel.clickSubject.onNext(())
        
        customView.scanBtn.rx.tap
            .bind(to: viewModel.clickSubject)
            .disposed(by: disposeBag)
        
        viewModel.peripheralRowItemsSubject
            .bind(to: customView.peripheralTableView.rx.items(cellIdentifier: String(describing: PeripheralTableViewCell.self),
                                                              cellType: PeripheralTableViewCell.self)) { (row, scanned, cell) in
                cell.scanned = scanned
                cell.setSelectTarget(self, action: #selector(self.didTapCell(_:)))
            }.disposed(by: disposeBag)
        
        viewModel.characteristicSubject
            .subscribe(onNext: {
                BannerService.shared.success(title: Constant.Strings.success, body: "Connected \($0.characteristic.uuid.uuidString).")
            })
            .disposed(by: disposeBag)
        
        viewModel.characteristicErrorSubject
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                BannerService.shared.error(title: Constant.Strings.error, body: "Can't find any characteristic.")
            })
            .disposed(by: disposeBag)
        
        viewModel.disconnectionOutput
            .subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let disconnection):
                    BannerService.shared.error(title: Constant.Strings.error, body: disconnection.1?.localizedDescription ?? Constant.Strings.defaultDisconnectionReason)
                case .error:
                    BannerService.shared.error(title: Constant.Strings.error, body: Constant.Strings.defaultDisconnectionReason)
                }
                
                self.customView.responseTextView.text.append("Disconnected.\n")
            })
            .disposed(by: disposeBag)
        
        viewModel.updatedValueAndNotificationOutput
            .subscribe(onNext: { [unowned self] result in
                var response = "==> "
                var updatedValue: String?
                
                switch result {
                case .success(let characteristic):
                    guard let value = characteristic.value else { return }
                    let message = String(decoding: value, as: UTF8.self)
                    updatedValue = message
                    if message.isReply {
                        response += "Reply: \(message)"
                    } else {
                        response += "Command: \(message)"
                    }
                case .error(let error):
                    response += error.localizedDescription
                }
                
                response += "\n"
                self.customView.responseTextView.text.append(response)
                
                guard let _updatedValue = updatedValue, let reply = _updatedValue.replyComponent else { return }
                print("Reply: \(reply)")
            })
            .disposed(by: disposeBag)
        
        viewModel.repliesSubject
            .subscribe(onNext: {
                let message = $0.reduce("", { $0 + String.CR + $1 })
                BannerService.shared.success(title: "All Replies", body: message)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.repliesSubject.asObservable(),
                                 Observable<NSInteger>.interval(.seconds(4), scheduler: MainScheduler.instance),
                                 resultSelector: { (replies, _) -> [String] in replies })
            .observeOn(MainScheduler.instance)
            .map { $0.map { CommandType.reply(from: $0) } }
            .map { CommandType.fetch(from: $0) }
            .map { CommandType.parameters($0, with: self.viewModel.peripheral) }
            .map { MessageRequest(parameters: $0) }
//            .flatMap { request -> Observable<Response> in
//                print("Message Sent:\n\(request)")
//                return APIClient.shared.get(apiRequest: request)
//            }
            .retry(3)
            .subscribe(onNext: {
                APIClient.shared.sendMessage(params: $0.parameters as NSDictionary, success: { print("Success: \($0)") }, failure: { print("Error: \($0)")})
                let resultToDisplay = $0.parameters.map { (field: String, value: Any) -> String in
                    field + ": " + String(describing: value)
                }.reduce("", { $0 + String.CR + $1})
                BannerService.shared.success(title: "Data to Send a Server", body: resultToDisplay)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func didTapCell(_ sender: PeripheralTableViewCell.TapGesture) {
        
    }
    
    private func testFunc() {
        print(APIClient().server)
        
        let _ = [
            "NO DATA\r\r\r>\r",
            "NO DATA\r\r\r>\r",
            "NO DATA\r\r\r>\r",
            "AT IGN\rON\r\r>\r",
            "AT IGN\rON\r\r>\r",
            "AT IGN\rON\r\r>\r",
            "AT RV\r14.7V\r\r>\r",
            "AT RV\r14.7V\r\r>\r",
            "AT RV\r14.7V\r\r>\r",
            "41 0C 54 1B\r41 0C 54 1B\r41 0C 54 1B\r>\r",
            "41 0C 54 1B\r41 0C 54 1B\r41 0C 54 1B\r>\r",
            "41 0C 54 1B\r41 0C 54 1B\r41 0C 54 1B\r>\r",
            "41 00 BE 3E 2F 00\r41 00 BE 3E 2F 00\r41 00 BE 3E 2F 00\r>\r",
            "41 00 BE 3E 2F 00\r41 00 BE 3E 2F 00\r41 00 BE 3E 2F 00\r>\r",
            "41 00 BE 3E 2F 00\r41 00 BE 3E 2F 00\r41 00 BE 3E 2F 00\r>\r",
        ]
        
        let replies = [
            "NO DATA\r\r\r>\r",
            "AT IGN\rON\r\r>\r",
            "AT RV\r14.7V\r\r>\r",
            "41 0C 54 1B",
            "41 0D BE 3E 2F 00"
        ]
        
        let _ = [
            Reply(mode: "AT RV", contents: ["14.7V"]),
            Reply(mode: "AT IGN", contents: ["ON"]),
            Reply(mode: "41 0D", contents: ["BE", "3E", "2F", "00"]),
            Reply(mode: "41 0C", contents: ["1B"]),
            Reply()
        ]
        if !Constant.IS_ELM327 && false {
            Observable.combineLatest(Observable.from(optional: replies),
                           Observable<NSInteger>.interval(.seconds(4), scheduler: MainScheduler.instance),
                           resultSelector: { (replies, _) -> [String] in replies })
            .observeOn(MainScheduler.instance)
            .map { $0.map { CommandType.reply(from: $0) } }
            .map { CommandType.fetch(from: $0) }
            .map { CommandType.parameters($0, with: self.viewModel.peripheral) }
            .map { MessageRequest(parameters: $0) }
            .retry(3)
            .subscribe(onNext: {
                print("Response from Server \($0)")
                let resultToDisplay = $0.parameters.map { (field: String, value: Any) -> String in
                    field + ": " + String(describing: value)
                }.reduce("", { $0 + String.CR + $1})
                BannerService.shared.success(title: "Data to Send a Server", body: resultToDisplay)
            })
            .disposed(by: disposeBag)
        }
    }
}
