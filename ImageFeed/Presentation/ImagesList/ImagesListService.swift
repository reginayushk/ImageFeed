//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 25.05.2023.
//

import Foundation

final class ImagesListService: ImagesListServiceProtocol {
    
    // MARK: - Private Properties
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int = .zero
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    // Static
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let didCatchFailure = Notification.Name(rawValue: "ImagesListServiceDidFail")
    
    // MARK: - Public
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        guard task == nil else { return }

        let nextPage = lastLoadedPage + 1
        
        let request = loadImagesRequest(page: nextPage)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            switch result {
            case .success(let body):
                let photos = body.map(Photo.from(_:))
                self.photos.append(contentsOf: photos)
                self.lastLoadedPage = nextPage
                
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": photos]
                    )
                
            case .failure(let error):
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didCatchFailure,
                        object: self,
                        userInfo: ["Error": error]
                    )
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let token = OAuth2TokenStorage().token else { return }
        
        let baseCompletion: (Result<PhotosLikeResult, Error>) -> Void = { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    self.photos[index] = newPhoto
                    completion(.success(Void()))
                }
                
            case .failure(let error):
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didCatchFailure,
                        object: self,
                        userInfo: ["Error": error]
                    )
                completion(.failure(error))
            }
        }
        
        if isLike {
            let request = likeOrDislikePhoto(token: token, id: photoId, httpMethod: "POST")
            let task = urlSession.objectTask(for: request, completion: baseCompletion)
            self.task = task
            task.resume()
        } else {
            let request = likeOrDislikePhoto(token: token, id: photoId, httpMethod: "DELETE")
            let task = urlSession.objectTask(for: request, completion: baseCompletion)
            self.task = task
            task.resume()
        }
    }
    
    func cleanImagesList() {
        self.photos = []
        self.lastLoadedPage = .zero
    }
    
    // MARK: - Private
    
    private func loadImagesRequest(page: Int) -> URLRequest {
        let request = URLRequest.makeHTTPRequest(
            path: "/photos"
            + "?client_id=\(accessKey)"
            + "&&page=\(page)"
            + "&&per_page=10",
            httpMethod: "GET",
            baseURL: URL(string: "https://api.unsplash.com") ?? URL(string: "")
        )
        return request
    }
    
    private func likeOrDislikePhoto(token: String, id: String, httpMethod: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos/\(id)/like",
            httpMethod: httpMethod,
            baseURL: URL(string: "https://api.unsplash.com") ?? URL(string: "")
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
