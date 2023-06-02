//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 19.05.2023.
//

import UIKit

final class ProfileImageService: ProfileImageServiceProtocol {
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession.shared
//    private let imageCache = NSCache<NSString, UIImage>()
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    // Static
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    // MARK: - Public
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let token = OAuth2TokenStorage().token else { return }
        task?.cancel()
        let request = profileRequest(token: token, username: username)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileUserResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let body):
                let avatarURL = body.profileImage.small
                self.avatarURL = avatarURL
                completion(.success(avatarURL ?? ""))
                self.task = nil
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL ?? ""]
                    )
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    func cleanProfileImage() {
        self.avatarURL = nil
    }
    
//    func getImage(from imageStringURL: String, completion: @escaping (UIImage?) -> Void) {
//        
//        DispatchQueue.global().async { [weak self] in
//            guard let self else { return }
//            if let cachedImage = self.imageCache.object(forKey: imageStringURL as NSString) {
//                return DispatchQueue.main.async {
//                    completion(cachedImage)
//                }
//            }
//            
//            guard let imageURL = URL(string: imageStringURL) else { return completion(nil) }
//            if let data = try? Data(contentsOf: imageURL), let image = UIImage(data: data) {
//                self.imageCache.setObject(image, forKey: imageStringURL as NSString)
//                DispatchQueue.main.async {
//                    completion(image)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            }
//        }
//    }
}

extension ProfileImageService {
    
    // MARK: - Private

    private func profileRequest(token: String, username: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET",
            baseURL: URL(string: "https://api.unsplash.com") ?? URL(string: "")
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
