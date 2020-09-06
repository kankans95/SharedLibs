//
//  SharedServices.swift
//  Shared
//
//  Created by kankan on 1/05/20.
//  Copyright © 2020 queuesafe. All rights reserved.
//

import Foundation
import Alamofire

public class SharedServices {
    
    public static func login(email: String, password: String, _ completionHandler: @escaping (ParsedResponse<String>) -> Void) {
        if var request = try? URLRequest(url: URL(string:"\(ServiceUtils.baseUrl)/v1/token")!, method:.get) {
            let authValue = "\(email):\(password)"
            let data = authValue.data(using: .utf8)
            let header = data!.base64EncodedString()
            request.setValue("Basic \(header)", forHTTPHeaderField: "Authorization")
            ServiceUtils.service.requestJSON(request, completionHandler)
        }
    }
    
    public static func signUp(email: String, password: String, _ completionHandler: @escaping (ParsedResponse<String>) -> Void) {
        if var request = try? URLRequest(url: URL(string:"\(ServiceUtils.baseUrl)/v1/accounts")!, method:.post) {
            request.configureRequestBody(body: User(email: email, password: password))
            ServiceUtils.service.requestJSON(request, completionHandler)
        }
    }
    
    public static func registerPush(token: String,
                                    app: String,
                                    _ completionHandler: @escaping (ParsedResponse<String>) -> Void) {
        if var request = try? URLRequest(url: URL(string:"\(ServiceUtils.baseUrl)/v1/push")!, method:.post) {
            if let identifier = UIDevice.current.identifierForVendor?.uuidString {
                request.configureRequestBody(body: PushRegInfo(Kind: 50, Token: token, Identifier: identifier, App: app))
                ServiceUtils.service.requestJSON(request, completionHandler)
                return
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}

struct User: Codable {
    let email: String
    let password: String
}

struct PushRegInfo: Codable {
    let Kind: Int
    let Token: String
    let Identifier: String
    let App: String
}
