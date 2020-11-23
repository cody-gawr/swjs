//
//  ApiRequest.swift
//  autobrain
//
//  Created by hope on 11/19/20.
//  Copyright © 2020 SWJG-Ventures, LLC. All rights reserved.
//

import Foundation
import Alamofire

public enum RequestType: String {
    case GET, POST
}

protocol APIRequest {
    var method: RequestType { get }
    var path: String { get }
    var parameters: [String: Any] { get }
}

extension APIRequest {
    
    func request(with baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL compoenents")
        }
        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String(describing: $1))
        }
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        let request: URLRequest = {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            return request
        }()
        
        return request
    }
}
