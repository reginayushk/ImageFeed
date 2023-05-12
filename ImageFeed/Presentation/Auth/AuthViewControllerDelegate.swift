//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 11.05.2023.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
