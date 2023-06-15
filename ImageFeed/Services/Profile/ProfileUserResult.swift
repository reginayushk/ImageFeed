//
//  ProfileUserResult.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 19.05.2023.
//

import Foundation

struct ProfileUserResult: Codable {
    let profileImage: UnsplashPhotoImages
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct UnsplashPhotoImages: Codable {
    let small: String?
}
