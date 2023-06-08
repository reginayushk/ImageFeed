//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 29.05.2023.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
