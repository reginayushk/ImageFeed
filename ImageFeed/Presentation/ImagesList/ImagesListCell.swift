//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 27.03.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {

    // Static
    static let reuseIdentifier = "ImagesListCell"
    
    
    // UI
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
        
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Public
    
    func configure(with indexPath: IndexPath, photoName: String) {
        guard let imagePhotosName = UIImage(named: photoName) else { return }
        
        self.contentImageView.image = imagePhotosName
        
        if indexPath.row % 2 == 0 {
            self.likeButton.setImage(UIImage(named: "likeButtonOn"), for: .normal)
        } else {
            self.likeButton.setImage(UIImage(named: "likeButtonOff"), for: .normal)
        }
        
        self.dateLabel.text = dateFormatter.string(from: Date())
    }
}
