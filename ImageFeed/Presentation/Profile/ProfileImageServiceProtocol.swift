//
//  ProfileImageServiceProtocol.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 20.05.2023.
//

import UIKit

protocol ProfileImageServiceProtocol: AnyObject {
    var avatarURL: String? { get }
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void)
//    func getImage(from imageStringURL: String, completion: @escaping (UIImage?) -> Void)
}
