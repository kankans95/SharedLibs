//
//  ServiceUtils.swift
//  Shared
//
//  Created by kankan on 1/05/20.
//  Copyright © 2020 queuesafe. All rights reserved.
//

import Foundation
import Alamofire
import JWTDecode

public class ServiceUtils {
    public static let service = QSSessionManager()
    
//    public static let service: QSSessionManager() = {
//        let url = URL(string: ServiceUtils.baseUrl)
//        let se: [String: ServerTrustPolicy] = [
//            url!.host! : .disableEvaluation
//        ]
//
//        let con = URLSessionConfiguration.default
//        con.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//        let manager = QSSessionManager(configuration: con, serverTrustPolicyManager: ServerTrustPolicyManager(policies: se))
//        return manager
//    }()
    
    public static let NetworkErrorMessage = "Please check your internet connectivity and try again later."
    public static let baseUrl = "https://api.queuesafe.net"
    fileprivate static let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    private static var accessToken: AccessToken?
    
    public static func getAccessToken() -> AccessToken? {
        if accessToken == nil, let savedTokenValue = DataAdapter.getAccessToken() {
            accessToken = AccessToken(tokenValue: savedTokenValue)
        }
        return accessToken
    }
    
    public static func setAccessToken(tokenValue: String) {
        accessToken = AccessToken(tokenValue: tokenValue)
        DataAdapter.saveAccessToken(token: tokenValue)
    }
    
    public static func clearAccessToken() {
        accessToken = nil
        DataAdapter.clearAccessToken()
    }
}

public extension URLRequest {
    public mutating func configureRequestBody<T: Codable>(body: T) {
        if let jsonData = try? ServiceUtils.jsonEncoder.encode(body) {
            self.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            self.httpBody = jsonData
        }
    }
}

public extension DefaultDataResponse {
    
    public func parseJSONResponse<T: Codable>() -> ParsedResponse<T> {
        var errorMessage: String? = nil
        var model: T? = nil
        
        if let _ = error {
            errorMessage = ServiceUtils.NetworkErrorMessage
            return ParsedResponse(model: model, errorMessage: errorMessage)
        }
        
        if response?.statusCode == 200 {
            if let data = self.data {
                if let object = try? JSONDecoder().decode(T.self, from: data) {
                    model = object
                }
            }
        } else {
            if let data = self.data,
                let errorJson = try? JSONSerialization.jsonObject(with: data, options: []),
                let errorDict = errorJson as? NSDictionary,
                let message = errorDict.object(forKey: "Message") as? String{
                errorMessage = message
            } else {
                errorMessage = "We are unable to validate your information. Please try again later."
            }
        }
        return ParsedResponse(model: model, errorMessage: errorMessage)
    }
}

public struct AccessToken {
    private var jwt: JWT?
    public let tokenValue: String
    
    init(tokenValue: String) {
        self.tokenValue = tokenValue
        var tokenValue = tokenValue
        let prefix = "Bearer "
        if tokenValue.hasPrefix(prefix) {
            tokenValue = String(tokenValue.dropFirst(prefix.count))
        }
        jwt = try? decode(jwt: tokenValue)
    }
    
    public func isExpired() -> Bool {
        guard let jwt = self.jwt else {
            return true
        }
        return jwt.expired
    }
    
    public func isManagerToken() -> Bool {
        guard let jwt = self.jwt else {
            return false
        }
        
        let queueInfo = jwt.claim(name: "QUEUE")
        if let queueInfoText = queueInfo.rawValue as? String {
            return queueInfoText.contains("QUEUE_NEXT")
        }
        return false
    }
}
