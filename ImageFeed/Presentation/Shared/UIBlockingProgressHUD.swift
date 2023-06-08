//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 14.05.2023.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {

    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func setUpAppearance() {
        ProgressHUD.animationType = .systemActivityIndicator
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorAnimation = .lightGray
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
