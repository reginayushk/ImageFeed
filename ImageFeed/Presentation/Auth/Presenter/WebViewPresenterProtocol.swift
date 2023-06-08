//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 04.06.2023.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
