//
//  ProfileAnimator.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 31.05.2023.
//

import UIKit

protocol ProfileAnimatorProtocol: AnyObject {
    func makeAnimation(view: UIView)
    func stopAllAnimations()
}

final class ProfileAnimator: ProfileAnimatorProtocol {
    
    // Static
    static let shared: ProfileAnimatorProtocol = ProfileAnimator()
    
    // Properties
    var animationLayers = Set<CALayer>()
    
    // MARK: - ProfileAnimatorProtocol
    
    func makeAnimation(view: UIView) {
        guard view.layer.animation(forKey: "locationsChange") == nil else { return }
        
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.cornerRadius = view.bounds.height / 2
        gradient.locations = [0, 0.1, 0.3]
        
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.masksToBounds = true
        
        animationLayers.insert(gradient)
        view.layer.addSublayer(gradient)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
    }
    
    func stopAllAnimations() {
        animationLayers.forEach { gradient in
            gradient.removeAllAnimations()
            gradient.removeFromSuperlayer()
        }
        
        animationLayers.removeAll()
    }
}
