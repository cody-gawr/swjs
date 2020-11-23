//
//  MainView.swift
//  Autobrain
//
//  Created by Kyle Smith on 7/31/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit
import WebKit

class MainView: UIView, WKScriptMessageHandler {
    lazy var webView: WKWebView = {
        let printScript = WKUserScript(source: "window.print = function() { window.webkit.messageHandlers.print.postMessage('print') }", injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        let controller = WKUserContentController()
        controller.addUserScript(printScript)
        controller.add(self, name: "print")
        
        let config = WKWebViewConfiguration()
        config.userContentController = controller
        config.processPool = WKProcessPool()
        let wv = WKWebView(frame: .zero, configuration: config)
        return wv
    }()
    
    //slow connection stuff
    let progressView: UIProgressView = {
        let pv = UIProgressView()
        pv.progress = 0
        pv.progressViewStyle = .bar
        pv.progressTintColor = ACCENT_COLOR_PURPLE
        pv.isHidden = true
        return pv
    }()
    
    let slowConnectionView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 8
        v.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        return v
    }()
    
    let slowConnectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 3
        label.text = "Your internet connection seems slow. This could take some time."
        return label
    }()
    
    let alertImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "alert")
        return iv
    }()
    
    var slowConnectionViewTopAnchor:NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        addSubview(webView)
        addSubview(progressView)
        
        if #available(iOS 11.0, *) {
            _ = webView.anchor(safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            _ = progressView.anchor(safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 3)
        } else {
            _ = webView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            _ = progressView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 3)
        }
        
        layoutIfNeeded()
        
    }
    
    func addSlowConnectionView() {
        addSubview(slowConnectionView)
        slowConnectionView.addSubview(slowConnectionLabel)
        slowConnectionView.addSubview(alertImageView)

        slowConnectionViewTopAnchor = slowConnectionView.topAnchor.constraint(equalTo: topAnchor, constant: frame.height)
        slowConnectionViewTopAnchor.isActive = true

        slowConnectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 44).isActive = true
        slowConnectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -44).isActive = true
        slowConnectionView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        
        _ = slowConnectionLabel.anchor(slowConnectionView.topAnchor, left: slowConnectionView.leftAnchor, bottom: slowConnectionView.bottomAnchor, right: slowConnectionView.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        slowConnectionLabel.centerYAnchor.constraint(equalTo: slowConnectionView.centerYAnchor).isActive = true


        alertImageView.topAnchor.constraint(equalTo: slowConnectionView.topAnchor, constant: 14).isActive = true
        alertImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        alertImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        alertImageView.centerXAnchor.constraint(equalTo: slowConnectionView.centerXAnchor).isActive = true

        layoutIfNeeded()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "print" {
            printCurrentPage()
        }
    }
    
    func printCurrentPage() {
        let printController = UIPrintInteractionController.shared
        let printFormatter = webView.viewPrintFormatter()
        printController.printFormatter = printFormatter
        
        let completionHandler: UIPrintInteractionController.CompletionHandler = { (printController, completed, error) in
            if !completed {
                if let e = error {
                    print("PRINT failed - " + e.localizedDescription)
                }
            }
        }
        
        printController.present(animated: true, completionHandler: completionHandler)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
