//
//  ProfileServiceProtocol.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 05.06.2023.
//

import Foundation

protocol ProfileServiceProtocol {
    var profile: Profile? { get }
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
    func cleanProfileInfo()
}
