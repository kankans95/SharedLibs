//
//  RequestIntercepter.swift
//  Shared
//
//  Created by kankan on 30/04/20.
//  Copyright © 2020 queuesafe. All rights reserved.
//

import Foundation
import Alamofire

public class QSSessionManager: SessionManager {
    
    public func requestJSON<T: Codable>(_ urlRequest: URLRequest, _ completionHandler: @escaping (ParsedResponse<T>) -> Void) {
        var request = urlRequest
        if let accessToken = ServiceUtils.getAccessToken() {
            request.setValue(accessToken.tokenValue, forHTTPHeaderField: "Authorization")
        }
        self.request(request).response { (response) in
            if let headers = response.response?.allHeaderFields as? [String: Any], let accessToken = headers["Www-Authenticate"] as? String{
                ServiceUtils.setAccessToken(tokenValue: accessToken)
            }
            completionHandler(response.parseJSONResponse())
        }
    }
}

public struct ParsedResponse<T> {
    public var model: T?
    public var errorMessage: String?
}

