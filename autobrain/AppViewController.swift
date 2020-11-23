//
//  AppViewController.swift
//  Autobrain
//
//  Created by Kyle Smith on 9/19/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit

class AppViewController: UIViewController {
    
    let alertContainer: UIView = {
        let view = UIView()
        view.backgroundColor = PRIMARY_COLOR_PURPLE
        view.accessibilityIdentifier = "alertView"
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        label.textAlignment = .center
        label.accessibilityIdentifier = "alertTitleLabel"
        return label
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.accessibilityIdentifier = "alertErrorLabel"
        return label
    }()
    
    var alertContainerTopAnchor: NSLayoutConstraint!
    var isAlertShowing = false
    var alertTimer = Timer()
    var parentView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showAlert(alertTitle: String, alertMessage: String, parent: UIView, topConstant: CGFloat = 0) {
        
        parentView = parent
        titleLabel.text = alertTitle
        errorLabel.text = alertMessage
        
        if !isAlertShowing {
            parent.addSubview(alertContainer)
            alertContainer.addSubview(titleLabel)
            alertContainer.addSubview(errorLabel)
            
            _ = alertContainer.anchor(nil, left: parent.leftAnchor, bottom: nil, right: parent.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 68)
            if #available(iOS 11.0, *) {
                alertContainerTopAnchor = alertContainer.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: -68)
            } else {
                alertContainerTopAnchor = alertContainer.topAnchor.constraint(equalTo: parent.topAnchor, constant: -68 + 20)
            }
            
            alertContainerTopAnchor.isActive = true
            
            _ = titleLabel.anchor(alertContainer.topAnchor, left: alertContainer.leftAnchor, bottom: nil, right: alertContainer.rightAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 18)
            _ = errorLabel.anchor(titleLabel.bottomAnchor, left: alertContainer.leftAnchor, bottom: nil, right: alertContainer.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 36)
            
            parent.layoutIfNeeded()
            if #available(iOS 11.0, *) {
                animateAlertFromTop(parent: parent, topConstant: 0)
            } else {
                animateAlertFromTop(parent: parent, topConstant: topConstant)
            }
            isAlertShowing = true
            startTimer()
        } else {
            titleLabel.text = alertTitle
            resetTimer()
        }
    }
    
    func startTimer() {
        alertTimer = Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(dismissAlertFromTop), userInfo: nil, repeats: false)
    }
    
    func resetTimer() {
        alertTimer.invalidate()
        startTimer()
    }
    
    func animateAlertFromTop(parent: UIView, topConstant: CGFloat) {
        alertContainerTopAnchor.constant = topConstant
        UIView.animate(withDuration: 0.5) {
            parent.layoutIfNeeded()
        }
    }
    
    @objc func dismissAlertFromTop() {
        alertContainerTopAnchor.constant = -68
        UIView.animate(withDuration: 0.5, animations: {
            self.parentView?.layoutIfNeeded()
        }) { (done) in
            self.alertContainer.removeFromSuperview()
            self.isAlertShowing = false
        }
    }
    
}
