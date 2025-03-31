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
    }()
    
    // MARK: Lifecycle
    
    init(viewModel: PhotoDetailsViewModel, photo: Photo) {
        self.viewModel = viewModel
        self.photo = photo
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
        
        viewModel.getPhoto(id: photo.id)
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
            
                updateFavoriteButtonTitle()
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
