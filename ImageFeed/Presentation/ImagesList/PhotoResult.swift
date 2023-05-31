//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 26.05.2023.
//

import Foundation

struct PhotosLikeResult: Codable {
    let photo: PhotoResult
}

struct PhotoResult: Codable {
    let urls: UrlsResult
    let id: String
    let createdAt: Date?
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    
    private enum CodingKeys: String, CodingKey {
        case urls
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case likedByUser = "liked_by_user"
    }
}

struct UrlsResult: Codable {
    let thumb: String?
    let full: String? 
}
