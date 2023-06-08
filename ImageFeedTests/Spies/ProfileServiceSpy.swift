//
//  ProfileServiceSpy.swift
//  ImageFeedTests
//
//  Created by Regina Yushkova on 05.06.2023.
//

@testable import ImageFeed
import Foundation

final class ProfileServiceSpy: ProfileServiceProtocol {
    
    var profileServiceCalled: Bool = false
    var profileGetCalled: Bool = false
    
    var profile: Profile? {
        get {
            profileGetCalled = true
            return nil
        }
    }

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
    }

    func cleanProfileInfo() {
        profileServiceCalled = true
    }
}
