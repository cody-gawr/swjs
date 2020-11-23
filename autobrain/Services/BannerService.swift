//
//  BannerService.swift
//  autobrain
//
//  Created by hope on 11/16/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit
import SwiftMessages

final class BannerService {
    
    static let shared = BannerService()
    
    private let config: SwiftMessages.Config = {
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = .seconds(seconds: 3)
        config.dimMode = .none
        
        return config
    }()
    
    private func buildView() -> MessageView {
        let view: MessageView
        view = MessageView.viewFromNib(layout: .cardView)
        view.titleLabel?.font = UIFont.systemFont(ofSize: Constant.FontSize.medium)
        view.bodyLabel?.font = UIFont.systemFont(ofSize: Constant.FontSize.small)
        view.button?.isHidden = true
        
        return view
    }
    
    func success(title: String = Constant.Strings.success, body: String) {
        let view: MessageView = buildView()
        view.configureContent(title: title, body: body)
        view.configureTheme(.success, iconStyle: .light)
        
        SwiftMessages.show(config: config, view: view)
    }
    
    func error(title: String = Constant.Strings.error, body: String) {
        let view: MessageView = buildView()
        view.configureContent(title: Constant.Strings.error, body: body)
        view.configureTheme(.error, iconStyle: .light)
        
        SwiftMessages.show(config: config, view: view)
    }
    
    func warning(title: String = Constant.Strings.warning, body: String) {
        let view: MessageView = buildView()
        view.configureContent(title: Constant.Strings.warning, body: body)
        view.configureTheme(.warning, iconStyle: .light)
        
        SwiftMessages.show(config: config, view: view)
    }
}
