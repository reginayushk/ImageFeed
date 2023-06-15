//
//  AlertFactory.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 23.05.2023.
//

import UIKit

final class AlertFactory {
    
    // Static
    static let shared = AlertFactory()
    
    // MARK: - Public
    
    func makeNetworkErrorAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(okAction)
        return alert
    }
}
