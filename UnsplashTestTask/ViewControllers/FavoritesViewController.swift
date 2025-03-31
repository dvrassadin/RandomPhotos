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
        bindToViewModel()
    }
    
    // MARK: Bind to ViewModel
    
    private func bindToViewModel() {
        viewModel.photos
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                
            }
            .store(in: &cancellables)
        
        try? viewModel.getPhotos()
    }

}
