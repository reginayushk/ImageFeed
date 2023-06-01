//
//  ImagesListServiceProtocol.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 26.05.2023.
//

import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    func cleanImagesList()
}
