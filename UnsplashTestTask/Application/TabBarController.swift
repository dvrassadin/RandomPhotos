//
//  TabBarController.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 29/3/25.
//

import UIKit

final class TabBarController: UITabBarController {

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        setupTabs()
    }
    
    // MARK: Setup TabBar
    
    private func setupTabs() {
        let photosTabBarItem = UITabBarItem(
            title: String(localized: "Photos"),
            image: UIImage(systemName: "photo.stack"),
            selectedImage: UIImage(systemName: "photo.stack.fill")
        )
        let photosVC = PhotosViewController()
        photosVC.tabBarItem = photosTabBarItem
        
        let favoritesTabBarItem = UITabBarItem(
            title: String(localized: "Favorites"),
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )
        let favoritesVC = FavoritesViewController()
        favoritesVC.tabBarItem = favoritesTabBarItem
        
        viewControllers = [photosVC, favoritesVC]
    }

}
