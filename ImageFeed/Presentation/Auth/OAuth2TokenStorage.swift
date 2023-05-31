//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 23.04.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    // MARK: - Properties
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "Auth token")
        } set {
            guard let newValue else { return KeychainWrapper.standard.remove(forKey: "Auth token") }
            KeychainWrapper.standard.set(newValue, forKey: "Auth token")
        }
    }
    
//    var token: String? {
//        get {
//            return UserDefaults.standard.string(forKey: "unsplashToken")
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "unsplashToken")
//        }
//    }
}
