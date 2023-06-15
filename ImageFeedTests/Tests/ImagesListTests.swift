//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Regina Yushkova on 05.06.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    var imagesListService: ImagesListServiceSpy!
    var presenter: ImagesListPresenter!
    
    override func setUp() {
        super.setUp()
        imagesListService = ImagesListServiceSpy()
        presenter = ImagesListPresenter(imagesListService: imagesListService)
    }
    
    override func tearDown() {
        imagesListService = nil
        presenter = nil
        super.tearDown()
    }
    
    func testFetchPhotosNextPage() {
        // when
        presenter.fetchPhotosNextPage()
        
        // then
        XCTAssertTrue(imagesListService.imagesListServiceCalled)
    }
    
    func testGetPhotos() {
        // when
        _ = presenter.getPhotos()
        
        // then
        XCTAssertTrue(imagesListService.photosGetCalled)
    }
    
    func testChangeLike() {
        // given
        let stubPhotoId = ""
        let stubIsLike = false
        
        // when
        presenter.changeLike(photoId: stubPhotoId, isLike: stubIsLike) { _ in }
        
        // then
        XCTAssertTrue(imagesListService.imagesListServiceCalled)
    }
}
