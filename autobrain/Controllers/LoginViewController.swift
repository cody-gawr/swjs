//
//  LoginViewController.swift
//  Autobrain
//
//  Created by Kyle Smith on 9/18/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit

class LoginViewController: AppViewController, UITextFieldDelegate {
    lazy var loginView: LoginView = {
        let lv = LoginView()
        lv.emailTextField.delegate = self
        lv.passwordTextField.delegate = self
        lv.accessibilityIdentifier = "loginView"
        return lv
    }()
    
    let termsViewController: TermsViewController = {
        let tvc = TermsViewController()
        tvc.documentType = .terms
        return tvc
    }()
    
    let privacyViewController: TermsViewController = {
        let tvc = TermsViewController()
        tvc.documentType = .privacy
        return tvc
    }()
    
    let splashScreen = SplashScreenView()
    
    let api: APIClient?
    let mainViewController: MainViewController?
    let defaults = UserDefaults.standard
    
    init(client: APIClient, mainViewController: MainViewController) {
        self.api = client
        self.mainViewController = mainViewController
        Session.current().viewController = mainViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()

        api!.authToken = defaults.object(forKey: "authToken") as? String ?? ""
        if api!.authToken != "" {
            api!.checkIfLoggedIn(success: { (response) in
            if response["logged_in"] == true || response["success"] == true {
                self.clearWebViewThenLoad()
            } else {
                self.splashScreen.removeFromSuperview()
                }
            }, failure: { (error) in
                debugPrint(error.localizedDescription)
                self.splashScreen.removeFromSuperview()
            })
        } else {
            splashScreen.removeFromSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        api!.setClient()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.backgroundColor = PRIMARY_COLOR_YELLOW
        
        //handle remembering last username entered
        if defaults.bool(forKey: "rememberMe") {
            loginView.rememberSwitch.isOn = true
            loginView.emailTextField.text = defaults.string(forKey: "userEmail")
        }
    }
    
    func setupViews() {
        view.addSubview(loginView)
        _ = loginView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        // Add splash screen while we are determining what to do
        view.addSubview(splashScreen)
        _ = splashScreen.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleTouPressed() {
        present(termsViewController, animated: true, completion: nil)
    }
    
    @objc func handlePrivacyPressed() {
        present(privacyViewController, animated: true, completion: nil)
    }
    
    @objc func handleDevicePressed() {
       UIApplication.shared.openURL(URL(string: "https://app.autobrain.com/buy")!)
    }
    
    @objc func handleCreatePressed() {
        mainViewController!.mainView.webView.load(URLRequest(url: URL(string: api!.server + "users/sign_up")!))
        perform(#selector(showHome), with: nil, afterDelay: 0.1)
    }
    
    @objc func handleForgotPressed() {
        mainViewController!.mainView.webView.load(URLRequest(url: URL(string: api!.server + "users/password/new")!))
        perform(#selector(showHome), with: nil, afterDelay: 0.1)
    }
    
    func clearWebViewThenLoad() {
        // Handle remote notifications
        UIApplication.shared.registerForRemoteNotifications()
        self.mainViewController!.mainView.webView.load(URLRequest(url: URL(string: "about:blank")!))
        self.mainViewController!.mainView.webView.load(URLRequest(url: URL(string: api!.server + "?token=" + api!.authToken)!))
        self.perform(#selector(self.showHome), with: nil, afterDelay: 0.01)
    }
    
    @objc func showHome(animated: Bool = false) {
        navigationController?.pushViewController(mainViewController!, animated: animated)
        self.splashScreen.removeFromSuperview()
        loginView.emailTextField.text = ""
        loginView.passwordTextField.text = ""
    }
    
    // MARK: - Login Button Functions
    @objc func loginPressedDown() {
        loginView.loginButton.layer.shadowOpacity = 0
    }
    
    @objc func handleLogin() {
        loginView.loginButton.layer.shadowOpacity = 0.55
        
        let defaults = UserDefaults.standard
        let emailText = loginView.emailTextField.text!
        let passwordText = loginView.passwordTextField.text!
        
        if(passwordText.utf8CString.count == 0 || emailText.utf8CString.count == 0) {
            showAlert(alertTitle: "Login Error", alertMessage: "Your username or password is empty!", parent: self.view)
        } else if !ReachabilityService.checkReachability() {
            showAlert(alertTitle: "Internet Issue", alertMessage: "Your internet seems to be offline. Please check your connection.", parent: self.view)
        } else {
            
            let params:NSDictionary = ["user":
                                            ["email":loginView.emailTextField.text,
                                             "password":loginView.passwordTextField.text]]
        
            api!.login(params: params, success: { (success) in
                if success["is_production"].exists() {
                    if success["is_production"] == true {
                        self.api!.setClient()
                    } else {
                        self.api!.setClient(environment: .staging)
                    }
                    
                    // handle setting the remember me email
                    if self.loginView.rememberSwitch.isOn {
                        defaults.set(true, forKey: "rememberMe")
                        defaults.set(self.loginView.emailTextField.text, forKey: "userEmail")
                        
                    } else {
                        defaults.set(self.loginView.emailTextField.text, forKey: "")
                        defaults.set(false, forKey: "rememberMe")
                    }
                    
                    // remove keyboard
                    self.view.endEditing(true)
                    
                    // Switch to about:blank before loading the server so the non-native login doesn't appear
                    self.clearWebViewThenLoad()
                    
                } else if success["error"] == "invalid login" {
                    self.showAlert(alertTitle: "Login Error", alertMessage: "Your username and password combination is incorrect.", parent: self.view)
                    self.loginView.passwordTextField.text = ""
                } else {
                    // I don't know how this happens, but probably need to log something if it does
                }
                
            // handle no server error
            }) { (error) in
                self.showAlert(alertTitle: "Server Error", alertMessage: "Our server seems to be having issues. Give us a moment.", parent: self.view)
                print(error)
            }
        }
    }
    
    // MARK: - UITextFieldDelegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        textField.layer.shadowColor = shadowColor.cgColor
        textField.layer.shadowOpacity = 1.0
        textField.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        textField.layer.shadowRadius = 4
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.shadowOpacity = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == loginView.emailTextField {
            loginView.passwordTextField.becomeFirstResponder()
        } else {
            handleLogin()
        }
        return true
    }
    
}
