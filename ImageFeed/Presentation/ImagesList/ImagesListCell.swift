//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 27.03.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {

    // Static
    static let reuseIdentifier = "ImagesListCell"
    
    // UI
    @IBOutlet private weak var contentImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
        
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    // MARK: - Private
    
    private let imagesListService: ImagesListServiceProtocol
    private let imagesListAnimator: ImagesListAnimatorProtocol
    private let gradient = CAGradientLayer()
    
    // MARK: - Public
    
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - Initialize
    
    init(
        imagesListService: ImagesListServiceProtocol = ImagesListService.shared,
        imagesListAnimator: ImagesListAnimatorProtocol = ImagesListAnimator.shared
    ) {
        self.imagesListService = imagesListService
        self.imagesListAnimator = imagesListAnimator
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.imagesListService = ImagesListService.shared
        self.imagesListAnimator = ImagesListAnimator.shared
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = contentImageView.frame
        gradient.cornerRadius = contentImageView.layer.cornerRadius
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentImageView.kf.cancelDownloadTask()
        imagesListAnimator.stopAnimation(view: self, gradient: gradient)
    }
    
    // MARK: - Public
    
    func configure(with indexPath: IndexPath, photo: Photo) {
        guard
            let photoImageURL = photo.thumbImageURL,
            let url = URL(string: photoImageURL)
        else { return }

        imagesListAnimator.makeAnimation(view: self, gradient: gradient)
        let indicator = KFIndicator()
        contentImageView.kf.indicatorType = .custom(indicator: indicator)
        contentImageView.kf.setImage(with: url, placeholder: UIImage(named: "square")) { [weak self] _ in
            guard let self else { return }
            self.imagesListAnimator.stopAnimation(view: self, gradient: self.gradient)
        }
        
        setIsLiked(photo.isLiked)
        
        if let date = photo.createdAt {
            self.dateLabel.text = dateFormatter.string(from: date)
        } else {
            self.dateLabel.text = ""
        }
    }
    
    func setIsLiked(_ isLiked: Bool) {
        if isLiked {
            likeButton.setImage(UIImage(named: "likeButtonOn"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "likeButtonOff"), for: .normal)
        }
    }
    
    // MARK: - Private
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}

final class KFIndicator: Indicator {
    
    let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.layer.cornerRadius = 8
        indicator.backgroundColor = .white
        indicator.color = .ypDarkGray
        return indicator
    }()
    
    var view: IndicatorView {
        return indicator
    }
    
    func startAnimatingView() {
        indicator.startAnimating()
    }
    
    func stopAnimatingView() {
        indicator.stopAnimating()
    }
    
    func sizeStrategy(in imageView: KFCrossPlatformImageView) -> IndicatorSizeStrategy {
        return .size(CGSize(width: 51, height: 51))
    }
}
