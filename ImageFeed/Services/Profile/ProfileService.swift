//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 19.05.2023.
//

import Foundation

final class ProfileService: ProfileServiceProtocol {
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    // Static
    static let shared = ProfileService()
    
    // MARK: - ProfileServiceProtocol
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let token = OAuth2TokenStorage().token else { return }
        task?.cancel()
        let request = profileRequest(token: token)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let body):
                let profile = Profile.from(body)
                self.profile = profile
                completion(.success(profile))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    func cleanProfileInfo() {
        self.profile = nil
    }
}

extension ProfileService {
    
    // MARK: - Private

    private func profileRequest(token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: URL(string: "https://api.unsplash.com") ?? URL(string: "")
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
