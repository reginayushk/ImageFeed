//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 08.06.2023.
//

import Foundation

protocol ImagesListPresenterProtocol {
    func fetchPhotosNextPage()
    func getPhotos() -> [Photo]
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}
