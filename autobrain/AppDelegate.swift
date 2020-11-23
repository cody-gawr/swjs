//
//  AppDelegate.swift
//  autobrain
//
//  Created by Vedran Ozir on 07/03/16.
//  Copyright © 2016 Vedran Ozir. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

var PRIMARY_COLOR_YELLOW = UIColor(red: 246/255, green: 236/255, blue: 40/255, alpha: 1)
var PRIMARY_COLOR_PURPLE = UIColor(red: 81/255, green: 2/255, blue: 155/255, alpha: 1)
var ACCENT_COLOR_PURPLE = UIColor(red:0.53, green:0.17, blue:0.80, alpha: 1)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    let carCategoryIdentifier = "CAR_ALERT"
    
    var window: UIWindow?
    let api = APIClient()
    private let rxBluetoothKitService = RxBluetoothKitService()
    
    let kRemoteNotificationsContext = "RemoteNotifications"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initOnFirstLaunch()
        resetStateIfUITesting()
        
        NRLogger.setLogLevels(NRLogLevelError.rawValue)
        NewRelic.start(withApplicationToken: "AA805b5ec87047e8af322371dc5d786e12c8792c21")
        
        //Push Notifications
        //Foreground notifications for iOS 10+
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
                //actions based on whether notications were authorized or not
                guard granted else { return }
                
                let viewAction = UNNotificationAction(identifier: "view", title: "View", options: [.foreground])
                let dismissAction = UNNotificationAction(identifier: "dismiss", title: "Dismiss", options: [.destructive])
                let carCategory = UNNotificationCategory(identifier: self.carCategoryIdentifier, actions: [viewAction, dismissAction], intentIdentifiers: [], options: [])
                center.setNotificationCategories([carCategory])
            })
            center.delegate = self
        } else {
            let settings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        //Setup
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = .black
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: (sharedApplication.delegate?.window??.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = PRIMARY_COLOR_PURPLE
            sharedApplication.delegate?.window??.addSubview(statusBar)
        } else {
            // Fallback on earlier versions
            sharedApplication.statusBarView?.backgroundColor = PRIMARY_COLOR_PURPLE
        }
        
        let appearance = UINavigationBar.appearance()
        
        appearance.barTintColor = PRIMARY_COLOR_YELLOW
        appearance.tintColor = .black
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        var launchWithNav = UINavigationController()
        
        if (Constant.APP_DEBUG) {
            launchWithNav = UINavigationController(rootViewController: PeripheralListViewController(rxBluetoothKitService))
        } else {
            launchWithNav = UINavigationController(rootViewController: LaunchViewController(client: api))
        }
        
        window?.rootViewController = launchWithNav
        
        return true
    }
    
    func initOnFirstLaunch() {
        let defaults = UserDefaults.standard
        
        if !defaults.bool(forKey: "HasLaunchedOnce"){
            defaults.set(true, forKey: "HasLaunchedOnce")
            defaults.synchronize()
        }
    }
    
    // MARK: UITest Functions
    private func resetStateIfUITesting() {
        if ProcessInfo.processInfo.arguments.contains("UI-Testing") {
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        }
    }
    
    
    //MARK: - Push Notification Delegate Methods
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) { }
    
    func applicationDidBecomeActive(_ application: UIApplication) { }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        
        api.enableApplePushToken(token: token, success: { (response) -> () in
            print("Succeded to register Apple Push Notification token to server")
            
        }, failure: { (error) -> () in
            print("Failed to register Apple Push Notification token to server")
        })
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // this should handle iOS 9 and below
        // We don't have the same access to the notification data as we do on iOS 10+, so hopefully it doesn't
        // set the badge count to 0 here
        if application.applicationState != UIApplication.State.active {
            if let notificationData = userInfo["data"] as? NSDictionary {
                if let alertUrl = notificationData["alert_url"] as? String{
                    DispatchQueue.main.async(execute: {
                        Session.current().viewController?.mainView.webView.load(URLRequest(url: URL(string: alertUrl)!))
                    })
                }
                
                if let alertId = notificationData["alert_id"] as? Int {
                    let params: NSDictionary = [ "alert_id": alertId]
                    api.updatePushNotificationReceived(params: params)
                }
            }
        }
        
        completionHandler(.newData)
    }
    
    //This method will be called when app received push notifications in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let notificationData = notification.request.content.userInfo["data"] as? NSDictionary {
            if let alertId = notificationData["alert_id"] as? Int {
                let params: NSDictionary = [ "alert_id": alertId]
                api.updatePushNotificationReceived(params: params)
            }
        }
        
        completionHandler([.alert, .badge, .sound])
    }
    
    //This method will handle push notifications from background
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Setting the badge count to zero clears all of the previous alerts, so don't let that happen
        if let badgeCount = response.notification.request.content.badge as? Int {
            if badgeCount == 0 {
                //set application badge indirectly with UILocalNotification
                let ln = UILocalNotification()
                ln.applicationIconBadgeNumber = -1
                UIApplication.shared.presentLocalNotificationNow(ln)
            }
            else {
                UIApplication.shared.applicationIconBadgeNumber = badgeCount
            }
        }
        
        if let notificationData = response.notification.request.content.userInfo["data"] as? NSDictionary {
            if var alertUrl = notificationData["alert_url"] as? String {
                alertUrl = String(alertUrl) + "?token=" + api.authToken
                
                DispatchQueue.main.async(execute: {
                    Session.current().viewController?.mainView.webView.load(URLRequest(url: URL(string: alertUrl)!))
                })
            }
            
            if let alertId = notificationData["alert_id"] as? Int {
                let params: NSDictionary = [ "alert_id": alertId]
                api.updatePushNotificationReceived(params: params)
            }
        }
        
        completionHandler()
    }
}

