//
//  PhotoDetailsViewController.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 30/3/25.
//

import UIKit
import Combine

final class PhotoDetailsViewController: UIViewController {
    
    // MARK: Dependencies
    
    private let viewModel: PhotoDetailsViewModel
    private lazy var contentView = PhotoDetailsView()
    
    // MARK: Properties
    
    private var cancellables: Set<AnyCancellable> = []
    private var photo: Photo
    private lazy var isPhotoFavorite: Bool = {
        viewModel.isPhotoFavoritePhoto(id: photo.id)
    }() {
        didSet {
            updateFavoriteButtonTitle()
        }
    }
    private let shouldFetchPhoto: Bool
    
    // MARK: Lifecycle
    
    init(viewModel: PhotoDetailsViewModel, photo: Photo, shouldFetchPhoto: Bool) {
        self.viewModel = viewModel
        self.photo = photo
        self.shouldFetchPhoto = shouldFetchPhoto
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
        contentView.setInitialPhoto(photo)
        bindToViewModel()
        subscribeToNotificationCenter()
        setupFavoriteButton()
    }
    
    // MARK: Bind to ViewModel
    
    private func bindToViewModel() {
        viewModel.photo
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photo in
                guard let self, let photo else { return }
                self.photo = photo
                contentView.addDetails(photo)
            }
            .store(in: &cancellables)
        
        if shouldFetchPhoto {
            viewModel.getPhoto(id: photo.id)
        }
    }
    
    // MARK: Subscribe to NotificationCenter
    
    private func subscribeToNotificationCenter() {
        NotificationCenter.default.publisher(for: .photosDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                isPhotoFavorite = viewModel.isPhotoFavoritePhoto(id: photo.id)
            }
            .store(in: &cancellables)
    }
    
    // MARK: Setup Favorite Button
    
    private func setupFavoriteButton() {
        updateFavoriteButtonTitle()
        contentView.favoriteButton.isHidden = false
        
        contentView.favoriteButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            
            do {
                isPhotoFavorite.toggle()

                if isPhotoFavorite {
                    try viewModel.addToFavorites(photo: photo)
                } else {
                    try viewModel.removeFromFavorites(id: photo.id)
                }
            } catch {
                isPhotoFavorite.toggle()
            }
        }, for: .touchUpInside)
    }

    private func updateFavoriteButtonTitle() {
        let title = isPhotoFavorite ?
            String(localized: "Remove from Favorites") :
            String(localized: "Add to Favorites")
        contentView.favoriteButton.configuration?.title = title
    }

}
