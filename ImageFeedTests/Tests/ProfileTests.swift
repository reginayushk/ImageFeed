//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Regina Yushkova on 05.06.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    var profileService: ProfileServiceSpy!
    var profileImageService: ProfileImageServiceSpy!
    var imagesListService: ImagesListServiceSpy!

    var presenter: ProfilePresenter!
    
    override func setUp() {
        super.setUp()
        profileService = ProfileServiceSpy()
        profileImageService = ProfileImageServiceSpy()
        imagesListService = ImagesListServiceSpy()

        presenter = ProfilePresenter(
            profileService: profileService,
            profileImageService: profileImageService,
            imagesListService: imagesListService
        )
    }
    
    override func tearDown() {
        profileService = nil
        profileImageService = nil
        imagesListService = nil

        presenter = nil
        super.tearDown()
    }
    
    func testFetchProfile() {
        // when
        _ = presenter.fetchProfile()

        // then
        XCTAssertTrue(profileService.profileGetCalled)
    }
    
    func testFetchProfileImageURL() {
        // given
        let stubProfile = Profile(username: "", name: "", loginName: "", bio: nil)

        // when
        presenter.fetchProfileImageURL(profile: stubProfile)
        
        // then
        XCTAssertTrue(profileImageService.profileImageServiceCalled)
    }
    
    func testFetchAvatarURL() {
        // when
        _ = presenter.fetchAvatarURL()
        
        // then
        XCTAssertTrue(profileImageService.avatarGetCalled)
    }
    
    func testClean() {
        // when
        presenter.clean()
        
        // then
        XCTAssertTrue(profileService.profileServiceCalled)
        XCTAssertTrue(profileImageService.profileImageServiceCalled)
        XCTAssertTrue(imagesListService.imagesListServiceCalled)
    }
}
