//
//  ImagesListAnimator.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 31.05.2023.
//

import UIKit

protocol ImagesListAnimatorProtocol {
    func makeAnimation(view: UIView, gradient: CAGradientLayer)
    func stopAnimation(view: UIView, gradient: CAGradientLayer)
}

final class ImagesListAnimator: ImagesListAnimatorProtocol {
    
    // Static
    static let shared: ImagesListAnimatorProtocol = ImagesListAnimator()

    // MARK: - ProfileAnimatorProtocol
    
    func makeAnimation(view: UIView, gradient: CAGradientLayer) {
        guard view.layer.animation(forKey: "locationsChange") == nil else { return }

        gradient.frame = view.bounds
        gradient.cornerRadius = view.layer.cornerRadius
        gradient.locations = [0, 0.1, 0.3]
        
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.masksToBounds = true

        view.layer.addSublayer(gradient)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
    }
    
    func stopAnimation(view: UIView, gradient: CAGradientLayer) {
        gradient.removeFromSuperlayer()
    }
}
