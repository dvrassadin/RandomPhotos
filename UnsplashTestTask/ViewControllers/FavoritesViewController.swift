//
//  FavoritesViewController.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 29/3/25.
//

import UIKit
import Combine

final class FavoritesViewController: UIViewController {
    
    // MARK: Dependencies
    
    private let viewModel: FavoritesViewModel
    private lazy var contentView = FavoritesView()
    
    // MARK: Properties
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Lifecycle
    
    init(viewModel: FavoritesViewModel) {
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
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }
    
    // MARK: Bind to ViewModel
    
    private func bindToViewModel() {
        viewModel.photos
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.contentView.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        try? viewModel.getPhotos()
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
            photo: photo,
            shouldFetchPhoto: false
        )
        
        navigationController?.pushViewController(photoDetailViewController, animated: true)
    }

}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.photos.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoritesTableViewCell.identifier,
            for: indexPath
        ) as! FavoritesTableViewCell
        
        let photo = viewModel.photos.value[indexPath.row]
        cell.configure(photo: photo)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let photo = viewModel.photos.value[indexPath.row]
        showPhotoDetails(for: photo)
    }
    
}
