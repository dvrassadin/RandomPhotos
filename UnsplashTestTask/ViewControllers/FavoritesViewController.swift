//
//  FavoritesViewController.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 29/3/25.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    // MARK: Dependencies
    
    private let viewModel: FavoritesViewModel
    private lazy var contentView = FavoritesView()
    
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

        // Do any additional setup after loading the view.
    }

}
