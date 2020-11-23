//
//  LoginView.swift
//  Autobrain
//
//  Created by Kyle Smith on 9/18/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//
import UIKit

class LoginView: BaseView {
    
    let container: UIView = {
        let view = UIView()
        return view
    }()
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "myautobrain-logo")
        return iv
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        label.text = "Welcome to Autobrain"
        return label
    }()
    
    let touButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Terms of Use", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        button.titleLabel?.textAlignment = .left
        button.addTarget(nil, action: #selector(LoginViewController.handleTouPressed), for: .touchUpInside)
        return button
    }()
    
    let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Privacy Policy", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        button.titleLabel?.textAlignment = .right
        button.addTarget(nil, action: #selector(LoginViewController.handlePrivacyPressed), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: LeftPaddedTextField = {
        let tf = LeftPaddedTextField()
        tf.placeholder = "Email"
        let borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        tf.layer.borderColor = borderColor.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 2
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        tf.returnKeyType = .next
        tf.backgroundColor = .white
        tf.accessibilityIdentifier = "emailTextField"
        return tf
    }()
    
    let passwordTextField: LeftPaddedTextField = {
        let tf = LeftPaddedTextField()
        tf.placeholder = "Password"
        let borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        tf.layer.borderColor = borderColor.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 2
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.isAccessibilityElement = true
        tf.returnKeyType = .done
        tf.accessibilityIdentifier = "passwordTextField"
        return tf
    }()
    
    let rememberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.text = "remember me"
        return label
    }()
    
    let rememberSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = PRIMARY_COLOR_PURPLE
        return sw
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("LOG IN", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        button.backgroundColor = PRIMARY_COLOR_PURPLE
        let borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        button.layer.borderColor = borderColor.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        button.layer.shadowRadius = 3
        button.layer.masksToBounds = false
        button.addTarget(nil, action: #selector(LoginViewController.loginPressedDown), for: .touchDown)
        button.addTarget(nil, action: #selector(LoginViewController.handleLogin), for: .touchUpInside)
        return button
    }()
    
    let forgotButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        button.addTarget(nil, action: #selector(LoginViewController.handleForgotPressed), for: .touchUpInside)
        return button
    }()
    
    let noAccountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        label.text = "Don't have an account?"
        return label
    }()
    
    let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(PRIMARY_COLOR_PURPLE, for: .normal)
        button.setTitle("SIGN UP", for: .normal)
        button.backgroundColor = .white
        let borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        button.layer.borderColor = borderColor.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        button.layer.shadowRadius = 3
        button.layer.masksToBounds = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        button.addTarget(nil, action: #selector(LoginViewController.handleCreatePressed), for: .touchUpInside)
        return button
    }()
    
    let deviceButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(PRIMARY_COLOR_PURPLE, for: .normal)
        button.setTitle("BUY A DEVICE", for: .normal)
        button.backgroundColor = .white
        let borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        button.layer.borderColor = borderColor.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        button.layer.shadowRadius = 3
        button.layer.masksToBounds = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        button.addTarget(nil, action: #selector(LoginViewController.handleDevicePressed), for: .touchUpInside)
        return button
    }()
    
    let itemPadding: CGFloat = 34
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = PRIMARY_COLOR_YELLOW
        addSubview(container)
        
        container.addSubview(iconImageView)
        container.addSubview(welcomeLabel)
        container.addSubview(emailTextField)
        container.addSubview(passwordTextField)
        container.addSubview(rememberLabel)
        container.addSubview(rememberSwitch)
        container.addSubview(loginButton)
        container.addSubview(forgotButton)
        container.addSubview(noAccountLabel)
        container.addSubview(createAccountButton)
        container.addSubview(deviceButton)
        
        container.addSubview(touButton)
        container.addSubview(privacyButton)
        
        if #available(iOS 11.0, *) {
            _ = container.anchor(safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        } else {
            _ = container.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        }
        
        _ = iconImageView.anchor(container.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 44, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 104, heightConstant: 56)
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = welcomeLabel.anchor(iconImageView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 26)
        _ = welcomeLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        _ = emailTextField.anchor(welcomeLabel.bottomAnchor, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, topConstant: 36, leftConstant: itemPadding, bottomConstant: 0, rightConstant: itemPadding, widthConstant: 0, heightConstant: 44)
        
        _ = passwordTextField.anchor(emailTextField.bottomAnchor, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, topConstant: 12, leftConstant: itemPadding, bottomConstant: 0, rightConstant: itemPadding, widthConstant: 0, heightConstant: 44)
        
        _ = rememberSwitch.anchor(passwordTextField.bottomAnchor, left: container.leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: itemPadding + 2, bottomConstant: 0, rightConstant: 0, widthConstant: 56, heightConstant: 0)
        
        _ = rememberLabel.anchor(nil, left: rememberSwitch.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 140, heightConstant: 20)
        _ = rememberLabel.centerYAnchor.constraint(equalTo: rememberSwitch.centerYAnchor).isActive = true
        
        _ = loginButton.anchor(rememberSwitch.bottomAnchor, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, topConstant: 8, leftConstant: itemPadding, bottomConstant: 0, rightConstant: itemPadding, widthConstant: 0, heightConstant: 44)
        
        _ = forgotButton.anchor(loginButton.bottomAnchor, left: container.leftAnchor, bottom: nil, right: container.rightAnchor, topConstant: 4, leftConstant: 28, bottomConstant: 0, rightConstant: 28, widthConstant: 0, heightConstant: 44)
        
        _ = noAccountLabel.anchor(forgotButton.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 14)
        _ = noAccountLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = createAccountButton.anchor(noAccountLabel.bottomAnchor, left: container.leftAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: itemPadding + 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        _ = createAccountButton.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.33).isActive = true
        
        _ = deviceButton.anchor(noAccountLabel.bottomAnchor, left: nil, bottom: nil, right: container.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: itemPadding + 12, widthConstant: 0, heightConstant: 40)
        _ = deviceButton.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.33).isActive = true
        
        _ = touButton.anchor(nil, left: container.leftAnchor, bottom: container.bottomAnchor, right: nil, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 108, heightConstant: 28)
        
        _ = privacyButton.anchor(nil, left: nil, bottom: container.bottomAnchor, right: container.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 108, heightConstant: 28)
    
        
        
        
    }
}
