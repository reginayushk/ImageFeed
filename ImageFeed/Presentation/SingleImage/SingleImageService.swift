//
//  SingleImageService.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 29.05.2023.
//

import Foundation

final class SingleImageService: SingleImageServiceProtocol {
    
    // MARK: - Private Properties
    private(set) var photoURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    // Static
    static let shared = SingleImageService()
    static let didChangeNotification = Notification.Name(rawValue: "SingleImageProviderDidChange")
    
    // MARK: - Public
    
    func fetchFullPhoto(id: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        let request = loadSingleImageRequest(id: id)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let body):
                let photoURL = body.urls.full
                self.photoURL = photoURL
                completion(.success(photoURL ?? ""))
                NotificationCenter.default
                    .post(
                        name: SingleImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": photoURL ?? ""]
                    )
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - Private
    
    private func loadSingleImageRequest(id: String) -> URLRequest {
        let request = URLRequest.makeHTTPRequest(
            path: "/photos/\(id)"
            + "?client_id=\(accessKey)",
            httpMethod: "GET",
            baseURL: URL(string: "https://api.unsplash.com") ?? URL(string: "")
        )
        return request
    }
}
