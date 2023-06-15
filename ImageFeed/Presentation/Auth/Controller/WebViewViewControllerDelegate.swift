//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 03.06.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
    func webViewViewControllerDidFail(_ vc: WebViewViewController)
}
