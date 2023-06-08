//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 05.06.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}
