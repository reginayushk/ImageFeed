//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 16.04.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {

    // UI
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    // Public Properties
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    // MARK: - Private Properties
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - Initialize
    
    init(presenter: WebViewPresenterProtocol? = WebViewPresenter(authHelper: AuthHelper())) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.presenter = WebViewPresenter(authHelper: AuthHelper())
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.accessibilityIdentifier = "UnsplashWebView"
        
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
            options: [],
            changeHandler: { [weak self] _, _ in
                guard let self else { return }
                self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
            })
    }
    
    // MARK: - WebViewViewControllerProtocol
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    // MARK: - Action
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

// MARK: - WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let code = (error as NSError).code
        if code == -1017 || code == -1009 {
            delegate?.webViewViewControllerDidFail(self)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}
