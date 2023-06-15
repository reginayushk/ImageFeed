//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 11.05.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    // UI
    private lazy var vectorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Vector")
        return imageView
    }()
    
    // Dependencies
    private let window: UIWindow
    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private let profileImageService: ProfileImageServiceProtocol
    
    // Computed Properties
    private var mainStoryboard: UIStoryboard {
        UIStoryboard(name: "Main", bundle: .main)
    }
    
    // MARK: - Initialize
    
    init(window: UIWindow, profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared) {
        self.window = window
        self.profileImageService = profileImageService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
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
        
        if let token = OAuth2TokenStorage().token {
            fetchProfile(token: token)
        } else {
            let auth = mainStoryboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
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
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
            }

            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                DispatchQueue.main.async { [weak self] in
                    let alert = AlertFactory.shared.makeNetworkErrorAlert()
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
            }
            
            switch result {
            case .success(let profile):
                self.fetchProfileImage(username: profile.username)
                DispatchQueue.main.async { [weak self] in
                    self?.switchToTabBarController()
                }
            case .failure:
                DispatchQueue.main.async { [weak self] in
                    let alert = AlertFactory.shared.makeNetworkErrorAlert()
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    private func fetchProfileImage(username: String) {
        profileImageService.fetchProfileImageURL(username: username) { _ in }
    }
}
