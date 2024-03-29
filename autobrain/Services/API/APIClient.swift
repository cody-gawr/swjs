//
//  APIClient.swift
//  Autobrain
//
//  Created by Kyle Smith on 8/3/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON
import RxSwift
import RxCocoa

class APIClient {
    
    public static let shared = APIClient()
    
    let kProductionFeUrl = Bundle.main.infoDictionary!["API_BASE_URL_ENDPOINT_FE"] as! String
    let kStagingFeUrl = Bundle.main.infoDictionary!["API_KICKBACK_URL_ENDPOINT_FE"] as! String
    let webhookUrl = URL(string: "http://192.168.50.131:3008")!
    
    public var server = ""
    
    //Facebook
    let facebookAppId = "1087509371281329"
    var authToken = ""
    
    func getAuthedHeaders() -> NSDictionary {
        return ["Accept"       : "application/json",
                "Content-Type" : "application/json",
                "X-Auth-Token" : self.authToken]
    }
        
    enum Environment {
        case production
        case staging
    }
    
    init() {
        setClient()
    }
    
    func setClient(environment: Environment = Environment.production) {
        switch environment {
            case .production:
                server = kProductionFeUrl
            case .staging:
                server = kStagingFeUrl
        }
    }
    
    //MARK - External Functions
    func enableApplePushToken(token: String,
                              success: @escaping (JSON) -> Void,
                              failure: @escaping (NSError) -> Void) {
        
        let params: NSDictionary = ["os"         : "ios",
                                    "push_token" : token]
        
        let url = self.server + "api/v2/add_push_token"
        return POST(urlString: url, parameters: params, headers: getAuthedHeaders(), success: { (responseObject) in
            success(responseObject)
        }, failure: failure)
    }
    
    func clearAuthToken(completionHandler: @escaping () -> Void) {
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "authToken")
        defaults.synchronize()
        authToken = ""
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
        
        setClient()
        completionHandler()
    }
    
    //MARK: - REST API Functions
    func GET(urlString: URLConvertible,
             headers: NSDictionary,
             success: @escaping (JSON) -> Void,
             failure: @escaping (NSError) -> Void) {
        
        Alamofire
            .request(urlString, method: .get, headers: headers as? HTTPHeaders)
            .responseJSON { (responseObject) -> Void in
                
                if responseObject.result.isSuccess {
                    let resJSON = JSON(responseObject.result.value!)
                    success(resJSON)
                }
                
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error as NSError)
                }
        }
    }
    
    //MARK: - REST API Functions
    func POST(urlString:URLConvertible,
              parameters:NSDictionary,
              headers:NSDictionary,
              success: @escaping (JSON) -> Void,
              failure: @escaping (NSError) -> Void) {
        
        Alamofire
            .request(urlString, method: .post, parameters: parameters as? Parameters, encoding: JSONEncoding.default, headers: headers as? HTTPHeaders)
            .responseJSON { (responseObject) -> Void in
                if responseObject.result.isSuccess {
                    let resJSON = JSON(responseObject.result.value!)
                    
                    if (responseObject.response?.statusCode)! >= 200 && (responseObject.response?.statusCode)! < 300 {
                        success(resJSON)
                    } else {
                        success(JSON(["error": "invalid login"]))
                    }
                }
                
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error as NSError)
                }
        }
    }
    
    func login(params: NSDictionary,
               success: @escaping (JSON) -> Void,
               failure: @escaping (NSError) -> Void) {
        
        let url = server + "api/v2/login"
        let headers:NSDictionary = ["Accept" : "application/json"]
        
        return POST(urlString: url, parameters: params, headers: headers, success: { (responseObject) in
            let defaults = UserDefaults.standard
            print(responseObject)
            if responseObject["auth_token"].exists() {
                self.authToken = responseObject["auth_token"].stringValue
                defaults.set(responseObject["auth_token"].rawString(), forKey: "authToken")
                defaults.synchronize()
            
                responseObject["is_production"] == true ? self.setClient() : self.setClient(environment: .staging)
            }
            
            success(responseObject)
        },
            failure: failure)
    }

    
    func forgotPassword(params: NSDictionary,
               success: @escaping (JSON) -> Void,
               failure: @escaping (NSError) -> Void) {
        
        let url = server + "users/password"
        let headers:NSDictionary = ["Accept" : "application/json"]
        
        return POST(urlString: url, parameters: params, headers: headers, success: { (responseObject) in
            success(responseObject["success"])
        },
                    failure: failure)
    }
    
    func createAccount(params: NSDictionary,
                        success: @escaping (JSON) -> Void,
                        failure: @escaping (NSError) -> Void) {
        
        let url = server + "users/"
        let headers:NSDictionary = ["Accept" : "application/json"]
        
        return POST(urlString: url, parameters: params, headers: headers, success: { (responseObject) in
            success(responseObject["auth_token"])
        },
                    failure: failure)
    }
    
    func checkRegistrationEmail(email: String,
                                success: @escaping (JSON) -> Void,
                                failure: @escaping (NSError) -> Void) {
        
        let url = server + "registration/check_email?email=" + email
        let headers:NSDictionary = ["Accept" : "application/json"]
        
        GET(urlString: url,
            headers: headers,
            success: {(responseObject) -> Void in
                success(responseObject["email_taken"])
        },
            failure:{(error) -> Void in
                failure(error)
        })
    }
    
    func checkIfLoggedIn(success: @escaping (JSON) -> Void,
                         failure: @escaping (NSError) -> Void) {
        
        let headers: NSDictionary = ["Accept" : "application/json"]
        let url = server + "?token=" + authToken
        
        GET(urlString: url,
            headers: headers,
            success: {(responseObject) -> Void in
                success(responseObject)
        },
            failure:{(error) -> Void in
                failure(error)
        })
    }
    
    func sendCustomerFeedback(params: NSDictionary,
                              success: @escaping (JSON) -> Void,
                              failure: @escaping (NSError) -> Void) {
        
        let url = server + "api/v2/send_customer_feedback"
        
        return POST(urlString: url, parameters: params, headers: getAuthedHeaders(), success: { (responseObject) in
            success(responseObject)
        },
                    failure: failure)
    }
    
    // Update the database with releveant information from the user interacting with the AppReviewController
    func updateFeedbackStatus(reviewRequestStatus: Int, reviewType: String) {
        
        let params:NSDictionary = ["review_request_status" : reviewRequestStatus,
                                   "review_type"           : reviewType]
        
        let url = server + "api/v2/update_review_request_status"
        
        return POST(urlString: url, parameters: params, headers: getAuthedHeaders(), success: { (responseObject) in }, failure: { _ in })
    }
    
    func updatePushNotificationReceived(params: NSDictionary) {
        let url = server + "api/v2/update_notification_received"
        return POST(urlString: url, parameters: params, headers: getAuthedHeaders(), success: { (responseObject) in }, failure: { _ in })
    }
    
    func sendMessage(params: NSDictionary,
                     success: @escaping (JSON) -> Void,
                     failure: @escaping (NSError) -> Void) {
        let url = "https://cs.autobrain.com/api/handle_bluetooth_webhook"
        return POST(urlString: url, parameters: params, headers: getAuthedHeaders(),
                    success: { (responseObject) in }, failure: { _ in })
    }
}

extension APIClient {
    
    func get<T: Codable>(apiRequest: APIRequest) -> Observable<T> {

        return Observable<T>.create { observer in
            let request = apiRequest.request(with: self.webhookUrl)
            let dataRequest = Alamofire.request(request.url!, headers: self.getAuthedHeaders() as? HTTPHeaders ).responseData { response in
                
                switch response.result {
                case .success(let data):
                    do {
                        let model: T = try JSONDecoder().decode(T.self, from: data)
                        observer.onNext(model)
                    } catch let error {
                        observer.onError(error)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
}
