//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 30.03.2023.
//

import UIKit
import Kingfisher
import WebKit

private extension CGFloat {
    static let profileImageViewCornerRadius: CGFloat = 35
    static let profileImageViewWidthAnchor: CGFloat = 70
}

final class ProfileViewController: UIViewController {
    
    // UI
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "user")
        imageView.layer.cornerRadius = .profileImageViewCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "leave"), for: .normal)
        button.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Екатерина Новикова"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ekaterina_nov"
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, world!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    // Dependencies
    private let profileService = ProfileService.shared
    private let profileImageService: ProfileImageServiceProtocol
    private let profileAnimator: ProfileAnimatorProtocol
    private let imagesListService: ImagesListServiceProtocol
    
    // MARK: - Private Properties
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Initialize
    
    init(
        profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared,
        profileAnimator: ProfileAnimatorProtocol = ProfileAnimator.shared,
        imagesListService: ImagesListServiceProtocol = ImagesListService.shared
    ) {
        self.profileImageService = profileImageService
        self.profileAnimator = profileAnimator
        self.imagesListService = imagesListService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.profileImageService = ProfileImageService.shared
        self.profileAnimator = ProfileAnimator.shared
        self.imagesListService = ImagesListService.shared
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
                self.profileAnimator.stopAllAnimations()
            }
        updateAvatar()
        
        let profile = profileService.profile ?? Profile(username: "", name: "", loginName: "", bio: "")
        updateProfileDetails(profile: profile)
        
        profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        profileAnimator.makeAnimation(view: profileImageView)
        profileAnimator.makeAnimation(view: nameLabel)
        profileAnimator.makeAnimation(view: nicknameLabel)
        profileAnimator.makeAnimation(view: infoLabel)
    }
    
    // MARK: - Private
    
    private func setUpUI() {
        view.backgroundColor = .ypDarkGray
        
        [profileImageView, logoutButton, nameLabel, nicknameLabel, infoLabel].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: .profileImageViewWidthAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: .profileImageViewWidthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            logoutButton.widthAnchor.constraint(equalToConstant: 20),
            logoutButton.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nicknameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor)
        ])
    }
    
    private func updateProfileDetails(profile: Profile) {
        DispatchQueue.main.async { [weak self] in
            guard
                let self
//                let avatarURL = self.profileImageService.avatarURL
            else { return }
            
            self.nameLabel.text = self.profileService.profile?.name
            self.nicknameLabel.text = self.profileService.profile?.loginName
            self.infoLabel.text = self.profileService.profile?.bio
            
//            self.profileImageService.getImage(from: avatarURL) { [weak self] image in
//                guard let self else { return }
//                self.profileImageView.image = image
//            }
        }
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }

        profileImageView.kf.setImage(with: url)
    }
    
    // Static
    static func clean() {
        ImagesListService.shared.cleanImagesList()
        ProfileService.shared.cleanProfileInfo()
        ProfileImageService.shared.cleanProfileImage()
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapLogoutButton() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(
            title: "Да",
            style: .default) { [weak self] _ in
                OAuth2TokenStorage().token = nil
                ProfileViewController.clean()
                
                guard let sceneDelegate = self?.view.window?.windowScene?.delegate as? SceneDelegate else { return }
                sceneDelegate.startSplashScreen()
            }
        
        let noAction = UIAlertAction(
            title: "Нет",
            style: .cancel) { _ in
                self.dismiss(animated: true)
            }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true)
    }
}
