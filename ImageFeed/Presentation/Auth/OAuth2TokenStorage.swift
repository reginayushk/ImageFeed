//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 23.04.2023.
//

import Foundation

final class OAuth2TokenStorage {
    
    // MARK: - Properties
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "unsplashToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "unsplashToken")
        }
    }
}
