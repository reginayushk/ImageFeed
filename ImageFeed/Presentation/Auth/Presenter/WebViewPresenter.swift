//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 04.06.2023.
//

import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // Dependencies
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    // MARK: - Initialize
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    // MARK: - WebViewPresenterProtocol
    
    func viewDidLoad() {
        let request = authHelper.authRequest()
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    // MARK: - Public
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
