//
//  ImagesListServiceSpy.swift
//  ImageFeedTests
//
//  Created by Regina Yushkova on 05.06.2023.
//

@testable import ImageFeed
import Foundation

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    
    var imagesListServiceCalled: Bool = false
    var photosGetCalled: Bool = false
    var photos: [Photo] {
        get {
            photosGetCalled = true
            return []
        }
    }

    func fetchPhotosNextPage() {
        imagesListServiceCalled = true
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        imagesListServiceCalled = true
    }

    func cleanImagesList() {
        imagesListServiceCalled = true
    }
}
