//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 05.06.2023.
//

import Foundation

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
}
