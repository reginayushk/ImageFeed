//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Regina Yushkova on 24.03.2023.
//

import UIKit

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {

    // UI
    @IBOutlet private var tableView: UITableView!
    
    // Public Properties
    var photos: [Photo] = []
    var cachedCellHeights: [IndexPath: CGFloat] = [:]
    var presenter: ImagesListPresenterProtocol?

    // MARK: - Private Properties

    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imagesListServiceObserver: NSObjectProtocol?
    
    // MARK: - Initialize
    
    init(
        presenter: ImagesListPresenterProtocol? = ImagesListPresenter()
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.presenter = ImagesListPresenter()
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.accessibilityIdentifier = "ImagesListTableView"
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateTableViewAnimated()
            }
        updateTableViewAnimated()
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didCatchFailure,
                object: nil,
                queue: .main,
                using: { [weak self] _ in
                    let alert = AlertFactory.shared.makeNetworkErrorAlert()
                    self?.present(alert, animated: true)
                })
        
        presenter?.fetchPhotosNextPage()
    }
    
    // MARK: - Public
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else { return }
            let photo = photos[indexPath.row]
            viewController.photo = photo
            
            let backItem = UIBarButtonItem()
            backItem.tintColor = .white
            navigationItem.backBarButtonItem = backItem
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private
    
    private func updateTableViewAnimated() {
        guard let presenter else { return }
        
        let newPhotos = presenter.getPhotos()
        let oldCount = photos.count
        let newCount = newPhotos.count
        
        self.photos = newPhotos
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cachedCellHeight = cachedCellHeights[indexPath] {
            return cachedCellHeight
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photos[indexPath.row].size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photos[indexPath.row].size.height * scale + imageInsets.top + imageInsets.bottom
        
        cachedCellHeights[indexPath] = cellHeight
        
        return cellHeight
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == photos.count else { return }
        presenter?.fetchPhotosNextPage()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        
        let photo = photos[indexPath.row]
        
        imageListCell.configure(with: indexPath, photo: photo)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        return imageListCell
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let presenter else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        presenter.changeLike(photoId: photo.id, isLike: !photo.isLiked, { result in
            switch result {
            case .success:
                self.photos = presenter.getPhotos()
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
            }
        })
    }
}

