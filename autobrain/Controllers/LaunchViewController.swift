//
//  LaunchViewController.swift
//  Autobrain
//
//  Created by Kyle Smith on 9/21/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    var loginViewController: LoginViewController?
    var mainViewController: MainViewController?
    var api: APIClient?
    
    init(client: APIClient) {
        self.api = client
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        mainViewController = MainViewController(client: api!)
        loginViewController = LoginViewController(client: api!, mainViewController: mainViewController!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.backgroundColor = PRIMARY_COLOR_YELLOW
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        api!.authToken = defaults.object(forKey: "authToken") as? String ?? ""
        if api!.authToken == "" {
            showLogin()
        } else {
            showHome()
        }
    }
    
    func showHome() {
        perform(#selector(showMainAppView), with: nil, afterDelay: 0.01)
    }
    
    func showLogin() {
        self.mainViewController!.mainView.webView.load(URLRequest(url: URL(string: "about:blank")!))
        perform(#selector(showLoginView), with: nil, afterDelay: 0.01)
    }
    
    @objc func showMainAppView() {
        mainViewController!.mainView.webView.load(URLRequest(url: URL(string: api!.server + "?token=" + api!.authToken)!))
        navigationController?.pushViewController(mainViewController!, animated: false)
    }
    
    @objc func showLoginView() {
        navigationController?.pushViewController(loginViewController!, animated: false)
    }
}
