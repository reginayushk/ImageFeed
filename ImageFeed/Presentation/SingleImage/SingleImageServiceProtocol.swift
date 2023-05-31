//
//  SingleImageServiceProtocol.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 29.05.2023.
//

import Foundation

protocol SingleImageServiceProtocol {
    var photoURL: String? { get }
    func fetchFullPhoto(id: String, _ completion: @escaping (Result<String, Error>) -> Void)
}
