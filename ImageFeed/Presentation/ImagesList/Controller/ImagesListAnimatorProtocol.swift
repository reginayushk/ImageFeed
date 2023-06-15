//
//  ImagesListAnimatorProtocol.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 03.06.2023.
//

import UIKit

protocol ImagesListAnimatorProtocol {
    func makeAnimation(view: UIView, gradient: CAGradientLayer)
    func stopAnimation(view: UIView, gradient: CAGradientLayer)
}
