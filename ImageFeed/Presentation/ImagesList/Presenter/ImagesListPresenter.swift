//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 08.06.2023.
//

import Foundation

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    // Dependencies
    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService: ImagesListServiceProtocol
    
    // MARK: - Initialize
    
    init(imagesListService: ImagesListServiceProtocol = ImagesListService.shared) {
        self.imagesListService = imagesListService
    }
    
    // MARK: - ImagesListPresenterProtocol
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func getPhotos() -> [Photo] {
        imagesListService.photos
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        imagesListService.changeLike(photoId: photoId, isLike: isLike) { result in
            completion(result)
        }
    }
}
