//
//  PhotoDetailsView.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 30/3/25.
//

import UIKit
import Kingfisher

final class PhotoDetailsView: UIView {
    
    // MARK: Properties
    
    private lazy var locationHeight = locationImageView.heightAnchor.constraint(equalToConstant: 20)

    // MARK: UI Components
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let dateImageView = UIImageView(image: UIImage(systemName: "calendar"))
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private let locationImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "map"))
        imageView.isHidden = true
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.isHidden = true
        return label
    }()
    
    private let downloadsImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "arrow.down.circle.fill"))
        imageView.isHidden = true
        return imageView
    }()
    
    private let downloadsLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.isHidden = true
        return label
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton(configuration: .borderedProminent())
        button.isHidden = true
        return button
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
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(locationImageView)
        contentView.addSubview(locationLabel)
        contentView.addSubview(downloadsImageView)
        contentView.addSubview(downloadsLabel)
        contentView.addSubview(favoriteButton)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateImageView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        downloadsImageView.translatesAutoresizingMaskIntoConstraints = false
        downloadsLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            // TODO: Make automatic ImageView height resizing
            imageView.heightAnchor.constraint(equalToConstant: 500),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            dateImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            dateImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dateImageView.heightAnchor.constraint(equalToConstant: 20),
            dateImageView.widthAnchor.constraint(equalTo: dateImageView.heightAnchor),
        
            dateLabel.leadingAnchor.constraint(equalTo: dateImageView.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: dateImageView.centerYAnchor),
            
            locationImageView.topAnchor.constraint(equalTo: dateImageView.bottomAnchor, constant: 8),
            locationImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            locationHeight,
            locationImageView.widthAnchor.constraint(equalTo: locationImageView.heightAnchor),
            
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 8),
            locationLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            
            downloadsImageView.topAnchor.constraint(equalTo: locationImageView.bottomAnchor, constant: 8),
            downloadsImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            downloadsImageView.heightAnchor.constraint(equalToConstant: 20),
            downloadsImageView.widthAnchor.constraint(equalTo: downloadsImageView.heightAnchor),
            
            downloadsLabel.leadingAnchor.constraint(equalTo: downloadsImageView.trailingAnchor, constant: 8),
            downloadsLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            downloadsLabel.centerYAnchor.constraint(equalTo: downloadsImageView.centerYAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: downloadsLabel.bottomAnchor, constant: 16),
            favoriteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            favoriteButton.heightAnchor.constraint(equalToConstant: 48),
            
            favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: Configure with Data
    
    func setInitialPhoto(_ photo: Photo) {
        imageView.kf.setImage(with: photo.urls.regular, placeholder: UIImage(systemName: "photo"))
        nameLabel.text = photo.user.name
        dateLabel.text = photo.createdAt.formatted(date: .long, time: .omitted)
    }
    
    func addDetails(_ photo: Photo) {
        if let location = photo.location {
            var locationString = location.city ?? ""
            
            if let country = location.country {
                if locationString.isEmpty {
                    locationString = country
                } else {
                    locationString.append(", \(country)")
                }
            }
            
            if !locationString.isEmpty {
                locationLabel.text = locationString
                locationImageView.isHidden = false
                locationLabel.isHidden = false
            } else {
                locationHeight.constant = 0
            }
        }
        
        if let downloads = photo.downloads {
            downloadsLabel.text = String(localized: "\(downloads) downloads")
            downloadsImageView.isHidden = false
            downloadsLabel.isHidden = false
        }
    }
    
}
