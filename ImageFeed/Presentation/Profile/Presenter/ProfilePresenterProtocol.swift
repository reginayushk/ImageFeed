//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 05.06.2023.
//

import Foundation

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func fetchProfile() -> Profile
    func fetchProfileImageURL(profile: Profile)
    func fetchAvatarURL() -> String?
    func clean()
}
