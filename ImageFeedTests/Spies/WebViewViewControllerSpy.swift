//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Regina Yushkova on 05.06.2023.
//

import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {

    // Public Properties
    var loadRequestCalled: Bool = false
    var presenter: WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {
        
    }

    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
