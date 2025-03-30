//
//  PhotosViewController.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 29/3/25.
//

import UIKit
import Combine

final class PhotosViewController: UIViewController {
    
    // MARK: Dependencies
    
    private let viewModel: PhotosViewModel
    private lazy var contentView = PhotosView()
    
    // MARK: Properties
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Lifecycle
    
    init(viewModel: PhotosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindToViewModel()
    }
    
    // MARK: Setup View
    
    private func setupView() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
    }
    
    // MARK: Bind to ViewModel
    
    private func bindToViewModel() {
        viewModel.isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.contentView.activityIndicatorView.startAnimating()
                } else {
                    self?.contentView.activityIndicatorView.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.photos
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photos in
                print(photos)
                self?.contentView.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.errorMessage
            .sink { [weak self] errorMessage in
                self?.showAlert(message: errorMessage)
            }
            .store(in: &cancellables)
        
        viewModel.getPhotos()
    }
    
    // MARK: Show Alert
    
    private func showAlert(message: String) {
        
    }

}

// MARK: - UICollectionViewDataSource

extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.photos.value.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.identifier,
            for: indexPath
        ) as! PhotoCollectionViewCell
        
        let photo = viewModel.photos.value[indexPath.item]
        cell.configure(with: photo)
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension PhotosViewController: UICollectionViewDelegate {
    
}
