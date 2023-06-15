//
//  ProfileImageServiceSpy.swift
//  ImageFeedTests
//
//  Created by Regina Yushkova on 05.06.2023.
//

@testable import ImageFeed
import Foundation

final class ProfileImageServiceSpy: ProfileImageServiceProtocol {
    
    var avatarGetCalled: Bool = false
    var profileImageServiceCalled: Bool = false
    var avatarURL: String? {
        get {
            avatarGetCalled = true
            return nil
        }
    }

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        profileImageServiceCalled = true
    }

    func cleanProfileImage() {
        profileImageServiceCalled = true
    }
}
