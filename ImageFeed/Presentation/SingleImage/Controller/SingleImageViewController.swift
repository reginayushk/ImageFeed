//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 31.03.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - Public
    
    var photo: Photo?
    
    // UI
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var backButton: UIButton!
    
    // Dependencies
    private let singleImageService: SingleImageServiceProtocol
    
    // MARK: - Private Properties
    
    private var singleImageServiceObserver: NSObjectProtocol?
    private var fullImageURL: String?
    private var image: UIImage?
    
    // MARK: - Initialize
    
    init(singleImageService: SingleImageServiceProtocol = SingleImageService.shared) {
        self.singleImageService = singleImageService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.singleImageService = SingleImageService.shared
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.accessibilityIdentifier = "BackButton"
        scrollView.delegate = self
        backButton.tintColor = .white
        scrollView.minimumZoomScale = 0.95
        scrollView.maximumZoomScale = 3
        updateFullImage(id: photo?.id ?? "")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centerImage()
    }
    // MARK: - Actions
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapShareButton() {
        let share = UIActivityViewController(
            activityItems: [image as Any],
            applicationActivities: nil
        )
        present(share, animated: true)
    }
    
    // MARK: - Private
    
    private func updateFullImage(id: String) {

        UIBlockingProgressHUD.show()
        singleImageService.fetchFullPhoto(id: id) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
            }
            
            switch result {
            case .success(let stringURL):
                self.fullImageURL = stringURL
                self.loadImage(stringUrl: stringURL)
            case .failure:
                DispatchQueue.main.async { [weak self] in
                    let alert = AlertFactory.shared.makeNetworkErrorAlert()
                    self?.present(alert, animated: true)
                }
            }
        }
    }

    private func loadImage(stringUrl: String) {
        guard let url = URL(string: stringUrl) else { return }

        imageView.kf.setImage(with: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let kfImage):
                let image = kfImage.image
                self.image = image
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так. Попробовать ещё раз?",
            message: "",
            preferredStyle: .alert
        )
        
        let dismissAction = UIAlertAction(title: "Не надо", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        
        let tryAgainAction = UIAlertAction(title: "Повторить", style: .destructive) { [weak self] _ in
            guard let self, let fullImageURL = self.fullImageURL else { return }
            self.loadImage(stringUrl: fullImageURL)
        }
        
        alert.addAction(dismissAction)
        alert.addAction(tryAgainAction)
        present(alert, animated: true)
    }
    
    private func centerImage() {
        let boundsSize = scrollView.bounds.size
        var frameToCenter = imageView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageView.frame = frameToCenter
    }
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerImage()
    }
}
