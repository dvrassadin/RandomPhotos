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
    private let initialPhoto: Photo
    
    // MARK: Lifecycle
    
    init(viewModel: PhotoDetailsViewModel, initialPhoto: Photo) {
        self.viewModel = viewModel
        self.initialPhoto = initialPhoto
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
        contentView.setInitialPhoto(initialPhoto)
        bindToViewModel()
    }
    
    // MARK: Bind to ViewModel
    
    private func bindToViewModel() {
        viewModel.photo
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photo in
                guard let self, let photo else { return }
                contentView.addDetails(photo)
            }
            .store(in: &cancellables)
        
        viewModel.getPhoto(id: initialPhoto.id)
    }

}
