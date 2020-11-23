//
//  ViewController.swift
//  Autobrain
//
//  Created by Kyle Smith.
//  Copyright © 2016 SWJG-Ventures, LLC. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation
import CoreLocation
import MapKit
import Reachability
import StoreKit

class MainViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate, WKScriptMessageHandler {
    
    // MARK: - Class Constants and Variables
    lazy var mainView: MainView = {
        let mv = MainView()
        mv.webView.uiDelegate = self
        mv.webView.navigationDelegate = self
        mv.webView.scrollView.delegate = self
        mv.accessibilityIdentifier = "mainView"
        mv.webView.configuration.userContentController.add(self, name: "reviewHandler")
        mv.webView.configuration.userContentController.add(self, name: "urlHandler")
        return mv
    }()
    
    // Quick reference to the API
    let api: APIClient?
    
    let kCoreLocationContext = "CoreLocation"

    // Determines if we should show the splash screen. Once everything gets merged together this can probably be removed
    var keepVisibleSplashScreen = true
    
    // Determines if the phone is registered for push notifications so we don't try on every request
    var hasRegisteredPushToken = false
    
    // A counter and timer to decide when to show the user that they are experiencing slow internet
    var slowNetworkCounter = 0.0
    var slowNetworkTimer = Timer()
    
    // Determines if we have animated the slowConnectionView onto the screen
    var slowConnectionViewHasAnimated = false
    
    // Stop progress bar from reversing
    var progressTracker: Float = 0
    
    // Reviews
    var isShowingReview = false

    init(client: APIClient) {
        self.api = client
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIView Delegate Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        Session.current().viewController = self
        
        setupViews()
        
        // When the webView starts, check the internet connection to see if we want to show no internet page
        checkReachabilityAndLoad()

        let webViewKeyPathsToObserve = ["loading", "estimatedProgress"]
        for keyPath in webViewKeyPathsToObserve {
            mainView.webView.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
        }
        
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let appConfig = "window._appConfig = { os: 'ios', appVersion: '\(currentVersion)', hasStatusBar: true, openUrlFeature: true}"
        let viewportScript = WKUserScript(source: appConfig, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        mainView.webView.configuration.userContentController.addUserScript(viewportScript)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // hide navigation
        navigationController?.isNavigationBarHidden = true
    }

    @objc func removeProgress() {
        mainView.progressView.isHidden = true
        mainView.progressView.progress = 0
        progressTracker = 0
    }
    
    fileprivate func setupViews() {
        view.addSubview(mainView)
        _ = mainView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        view.layoutIfNeeded()
    }
    
    func handleWvLoading() {
        startPageLoadingVisual()
    }
    
    func handleWvFinished() {
        //handle animations and stuff
        finishPageLoadingVisual()
    }
    
    func startPageLoadingVisual() {
        //unhide
        mainView.slowConnectionView.isHidden = false
        slowNetworkTimer = Timer.scheduledTimer(timeInterval: 18, target: self, selector: #selector(handleNetworkTimer), userInfo: nil, repeats: false)
        
    }
    
    func finishPageLoadingVisual() {
        
        //handle slow internet connection
        mainView.slowConnectionView.removeFromSuperview()
        slowConnectionViewHasAnimated = false
        slowNetworkTimer.invalidate()
        
        if keepVisibleSplashScreen {
            self.keepVisibleSplashScreen = false
        }
    }
    
    @objc func handleNetworkTimer() {
        slowNetworkTimer.invalidate()
        
        if !slowConnectionViewHasAnimated {
            slowConnectionViewHasAnimated = true
            mainView.addSlowConnectionView()
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.mainView.slowConnectionViewTopAnchor.constant = self.view.frame.height/2 - 64
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func checkReachabilityAndLoad() {
        if ReachabilityService.checkReachability() {
            //this will have to be managed another way
        } else {
            handleNoInternet()
        }
    }
    
    func handleNoServer() {
        let noServer = LoadingIssueView()
        noServer.titleLabel.text = "We're Experiencing Issues"
        noServer.infoLabel.text = "Our server seems to be down. Please give us a moment."
        present(noServer, animated: true, completion: nil)
    }
    
    func handleNoInternet() {
        let noInternet = LoadingIssueView()
        present(noInternet, animated: true, completion: nil)
    }
    
    func openAppleMaps(url: URL) {
        
        var lat = url.absoluteString
        var long = url.absoluteString
        if let dotRange = lat.range(of: "addr=") {
            lat = lat.substring(with: dotRange.upperBound..<(lat.range(of: ",")?.lowerBound)!)
        }
        
        if let dotRange = long.range(of: ",") {
            long = long.substring(with: dotRange.upperBound..<long.endIndex)
        }
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(Double(lat)!, Double(long)!)
        let regionSpan = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "My Car"
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    //MARK: - WebView Delegate Methods
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let url = navigationAction.request.url
        debugPrint(navigationAction)
        
        if navigationAction.targetFrame == nil {
            //Twitter & Facebook Shares
            if (url!.host?.contains("facebook.com") == true  || url!.host?.contains("twitter") == true) {
                UIApplication.shared.openURL(url!)
            }
        }
        
        return nil
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.url ?? "URL is empty")
        
        if !ReachabilityService.checkReachability() {
            handleNoInternet()
            decisionHandler(.cancel)
            return
        }
        
        // Handle telephone call
        if navigationAction.request.url?.scheme == "tel" {
            UIApplication.shared.openURL(navigationAction.request.url!)
            decisionHandler(.cancel)
            return
        }

        let url = navigationAction.request.url
        
        //Buy Page
        if url!.path.contains("/buy") {
            UIApplication.shared.openURL(URL(string: "https://app.autobrain.com/buy")!)
        }
       
        //Handle Maps
        if url!.host?.contains("maps.apple.com") == true {
            openAppleMaps(url: url!)
        }
        
        // handle logout & handle the rare event that it ends up on /users/sign_in
        if url!.path.contains("/logout") || url!.path.contains("/sign_in"){
            hasRegisteredPushToken = false
            api!.clearAuthToken(completionHandler: { 
                self.navigationController?.popViewController(animated: true)
            })
        }
        
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if error._code == NSURLErrorCannotConnectToHost { //error -1004
            handleNoServer()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)  {
        // error codes -1000, -1001, -1003, -1004, -1005, -1006, -1011
        let badCodes = [NSURLErrorBadURL, NSURLErrorTimedOut, NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost, NSURLErrorNetworkConnectionLost, NSURLErrorDNSLookupFailed,NSURLErrorBadServerResponse]
        // This happens when clicking a link while another is already loading
        if (error._code == NSURLErrorCancelled) {
            return; // this is Error -999
        } else if badCodes.contains(error._code) {
            handleNoServer()
        } // error handling for "real" errors here
        
        debugPrint("webView didFailLoadWithError error: \(error)")
        
        // Reachability Addition - Swift 3
        do {
            let reachability: Reachability = Reachability.init()!
            
            switch reachability.connection {
            case .wifi, .cellular:
                // Network available
                
                self.startPageLoadingVisual()
                webView.load(URLRequest(url: URL(string: api!.server)!))
            case .none:
                // Network not available
                ask("Cannot access web page", message: error.localizedDescription /*?? "Internet may be unreachable"*/, title1: "Close", title2: "Retry", handler1: { (UIAlertAction) in
                    // Application should terminate here; for now just reload
                    self.startPageLoadingVisual()
                    webView.load(URLRequest(url: URL(string: self.api!.server)!))
                }, handler2: { (UIAlertAction) in
                    self.startPageLoadingVisual()
                    webView.load(URLRequest(url: URL(string: self.api!.server)!))
                })
            }
        }
        
        if !keepVisibleSplashScreen {
            finishPageLoadingVisual()
        }
        
        checkReachabilityAndLoad()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mainView.webView.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        finishPageLoadingVisual()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let statusCode = (navigationResponse.response as? HTTPURLResponse)?.statusCode else {
                decisionHandler(.allow)
                return
        }
        
        if statusCode >= 400 {
            present(LoadingIssueView(), animated: true, completion: nil)
        }
        
        decisionHandler(.allow)
    }
    
    //MARK: - ScrollView Delegate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if (scrollView.contentOffset.y <= 0) {
            scrollView.contentOffset.y = 0
        }
    }
    
    //MARK: - UserContentController Delegate Methods
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "urlHandler" {
            if let url = URL(string: message.body as! String), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        } else if message.name == "reviewHandler" && isShowingReview == false {
            isShowingReview = true
            _ = FeedbackBuilder(parentView: mainView, reviewType: message.body as! String, client: api!)
        }
    }
    
    // MARK: - KVO functions
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }
        guard let change = change else { return }
        
        switch keyPath {
        case "loading":
            if let loading = change[.newKey] as? Bool {
                if loading {
                    handleWvLoading()
                } else {
                    //done loading
                    handleWvFinished()
                }
            }
        case "estimatedProgress":
            //handle progress bar
            let wv = object as! WKWebView
            if (wv.url?.absoluteString.contains(api!.server)) == true {
                UIView.animate(withDuration: 0.4, animations: {
                    self.mainView.progressView.isHidden = false
                    let progress = Float(self.mainView.webView.estimatedProgress)
                    if progress >= self.progressTracker {
                        self.progressTracker = progress
                        self.mainView.progressView.setProgress(progress, animated: true)
                    }
                    if self.mainView.webView.estimatedProgress == 1 {
                        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.removeProgress), userInfo: nil, repeats: false)
                    }
                })
            }
        default:
            break
        }
    }
}

