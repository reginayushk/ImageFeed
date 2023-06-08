//
//  ProfileAnimatorProtocol.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 04.06.2023.
//

import UIKit

protocol ProfileAnimatorProtocol: AnyObject {
    func makeAnimation(view: UIView)
    func stopAllAnimations()
}
