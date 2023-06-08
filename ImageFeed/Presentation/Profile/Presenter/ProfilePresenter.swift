//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 05.06.2023.
//

import Foundation
import WebKit

final class ProfilePresenter: ProfilePresenterProtocol {
    
    // Dependencies
    weak var view: ProfileViewControllerProtocol?
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let imagesListService: ImagesListServiceProtocol
    
    // MARK: - Initialize
    
    init(
        profileService: ProfileServiceProtocol = ProfileService.shared,
        profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared,
        imagesListService: ImagesListServiceProtocol = ImagesListService.shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.imagesListService = imagesListService
    }

    // MARK: - ProfilePresenterProtocol
    
    func fetchProfile() -> Profile {
        return profileService.profile ?? Profile(username: "", name: "", loginName: "", bio: "")
    }
    
    func fetchProfileImageURL(profile: Profile) {
        profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
    }
    
    func fetchAvatarURL() -> String? {
        return profileImageService.avatarURL
    }
    
    func clean() {
        imagesListService.cleanImagesList()
        profileService.cleanProfileInfo()
        profileImageService.cleanProfileImage()
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
