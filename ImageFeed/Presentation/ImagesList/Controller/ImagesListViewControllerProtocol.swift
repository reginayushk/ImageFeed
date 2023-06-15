//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 08.06.2023.
//

import Foundation

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
}
