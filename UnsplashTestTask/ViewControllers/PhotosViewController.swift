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
    
    // MARK: UI Components
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = String(localized: "Photo Search")
        return searchController
    }()
    
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
        setupUI()
        bindToViewModel()
    }
    
    // MARK: UI Setup
    
    private func setupUI() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.title = String(localized: "Photos")
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
        let alertController = UIAlertController(
            title: String(localized: "Error"),
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: String(localized: "OK"), style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    // MARK: Show Photo Details
    
    private func showPhotoDetails(for photo: Photo) {
        let networkService = DefaultNetworkServices.shared
        let photoDetailViewModel = DefaultPhotoDetailsViewModel(
            networkService: networkService,
            modelContext: ModelContextProvider.shared.context
        )
        let photoDetailViewController = PhotoDetailsViewController(
            viewModel: photoDetailViewModel,
            photo: photo
        )
        
        navigationController?.pushViewController(photoDetailViewController, animated: true)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let initialPhoto = viewModel.photos.value[indexPath.item]
        showPhotoDetails(for: initialPhoto)
    }
    
}

// MARK: - UISearchBarDelegate

extension PhotosViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.searchTextField.text,
              !text.filter({ !$0.isWhitespace }).isEmpty else {
            viewModel.getPhotos()
            return
        }
        
        viewModel.searchPhotos(query: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getPhotos()
    }
    
}
