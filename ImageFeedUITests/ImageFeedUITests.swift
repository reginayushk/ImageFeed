//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Regina Yushkova on 08.06.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false

        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()

        let webView = app.webViews["UnsplashWebView"]
        sleep(5)

        let loginTextField = webView.descendants(matching: .textField).element
        loginTextField.tap()
        loginTextField.typeText("")
        sleep(2)
        app.toolbars.buttons["Done"].tap()

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        passwordTextField.tap()
        passwordTextField.typeText("")
        sleep(2)
        app.toolbars.buttons["Done"].tap()
        
        let webViewsQuery = app.webViews
        webViewsQuery.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        sleep(4)
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        let likeButton = cellToLike.buttons["LikeButton"]
        likeButton.tap()
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5))

        likeButton.tap()
        sleep(4)
        
        cell.tap()
        sleep(4)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let backButton = app.buttons["BackButton"]
        backButton.tap()
        XCTAssertTrue(likeButton.waitForExistence(timeout: 3))
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["NameLabel"].exists)
        XCTAssertTrue(app.staticTexts["NicknameLabel"].exists)
        
        app.buttons["LogoutButton"].tap()
        sleep(2)
        app.alerts["LogoutAlert"].scrollViews.otherElements.buttons["OK"].tap()
        sleep(4)
    }
}
