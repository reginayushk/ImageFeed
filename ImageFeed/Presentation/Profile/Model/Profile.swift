//
//  Profile.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 19.05.2023.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    static func from(_ profileResult: ProfileResult) -> Profile {
        Profile(
            username: profileResult.username,
            name: "\(profileResult.firstName) \(profileResult.lastName ?? "")",
            loginName: "@\(profileResult.username)",
            bio: profileResult.bio
        )
    }
}
