//
//  Photo.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 25.05.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    let isLiked: Bool
    
    static func from(_ photoResult: PhotoResult) -> Photo {
        Photo(
            id: photoResult.id,
            size: CGSize(width: photoResult.width, height: photoResult.height),
            createdAt: photoResult.createdAt,
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.thumb ?? "",
            largeImageURL: photoResult.urls.full ?? "",
            isLiked: photoResult.likedByUser)
    }
}
