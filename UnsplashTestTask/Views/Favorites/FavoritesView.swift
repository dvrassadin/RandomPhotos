//
//  FavoritesView.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 30/3/25.
//

import UIKit

final class FavoritesView: UIView {

    // MARK: UI components
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            FavoritesTableViewCell.self,
            forCellReuseIdentifier: FavoritesTableViewCell.identifier
        )
        return tableView
    }()
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Setup

    private func setupSubviews() {
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
