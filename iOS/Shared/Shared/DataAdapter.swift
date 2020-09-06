//
//  DataAdapter.swift
//  Shared
//
//  Created by kankan on 30/04/20.
//  Copyright © 2020 queuesafe. All rights reserved.
//

import Foundation
import KeychainAccess

public class DataAdapter {
    private static let accessTokenKey = "AccessToken"
    private static let pushTokenKey = "PushToken"
    private static let emailKey = "Email"
    
    private static var keychain: Keychain? = {
        if let identifier = Bundle.main.bundleIdentifier {
            return Keychain(service: identifier)
        }
        return nil
    }()
    
    private static func saveInfo(_ key: String, value: String) {
        if let keychain = keychain {
            keychain[key] = value
        }
    }
    
    private static func getString(key: String) -> String? {
        if let keychain = keychain {
            do {
                return try keychain.getString(key)
            } catch _ {
            }
        }
        return nil
    }
    
    private static func clearInfo(_ key: String) {
        if let keychain = keychain {
            do {
                try keychain.remove(key)
            } catch _ {}
        }
    }
    
    static func getAccessToken() -> String? {
        return getString(key: accessTokenKey)
    }
    
    public static func getPushToken() -> String? {
        return getString(key: pushTokenKey)
    }
    
    public static func getEmail() -> String? {
        return getString(key: emailKey)
    }
    
    static func saveAccessToken(token: String) {
        saveInfo(accessTokenKey, value: token)
    }
    
    public static func savePushToken(token: String) {
        saveInfo(pushTokenKey, value: token)
    }
    
    public static func saveEmail(email: String) {
        saveInfo(emailKey, value: email)
    }
    
    static func clearAccessToken() {
        clearInfo(accessTokenKey)
    }
    
    public static func clearPushToken() {
        clearInfo(pushTokenKey)
    }
    
    public static func clearEmail() {
        clearInfo(emailKey)
    }
}
