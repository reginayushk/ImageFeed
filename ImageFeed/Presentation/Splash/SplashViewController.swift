//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 11.05.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // UI
    private lazy var vectorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Vector")
        return imageView
    }()
    
    // MARK: - Dependencies

    private let window: UIWindow
    private let oauth2Service = OAuth2Service()
    
    // Computed Properties
    private var mainStoryboard: UIStoryboard {
        UIStoryboard(name: "Main", bundle: .main)
    }
    
    // MARK: - Initialize
    
    init(window: UIWindow) {
        self.window = window
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypDarkGray
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = OAuth2TokenStorage().token {
            switchToTabBarController()
        } else {
            let navigation = mainStoryboard.instantiateViewController(withIdentifier: "AuthNavigationController") as? UINavigationController
            let auth = navigation?.viewControllers.first as? AuthViewController
            auth?.delegate = self

            window.rootViewController = auth
            window.makeKeyAndVisible()
        }
    }
    
    // MARK: - Private
    
    private func setUpUI() {
        view.addSubview(vectorImageView)
        
        NSLayoutConstraint.activate([
            vectorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vectorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func switchToTabBarController() {
        window.rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "AuthorizedTabBarController")
        window.makeKeyAndVisible()
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure:
                // TODO [Sprint 11]
                break
            }
        }
    }
}
