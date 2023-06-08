//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 14.04.2023.
//

import Foundation

let AccessKey = "pYIROIT9jSMc7vGy3s9sqNWiR86-tp89NcxU2k8uURU"
let SecretKey = "Qpp9PaZ414LgkrjxVwfRVxQpb_bP6nyA258Tk-59nQA"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let DefaultBaseURL: URL? = URL(string: "https://api.unsplash.com/")
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: AccessKey,
            secretKey: SecretKey,
            redirectURI: RedirectURI,
            accessScope: AccessScope,
            defaultBaseURL: DefaultBaseURL ?? URL(fileURLWithPath: ""),
            authURLString: UnsplashAuthorizeURLString
        )
    }
}
