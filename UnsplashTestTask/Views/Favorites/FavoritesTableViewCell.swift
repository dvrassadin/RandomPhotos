//
//  FavoritesTableViewCell.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 31/3/25.
//

import UIKit
import Kingfisher

final class FavoritesTableViewCell: UITableViewCell {
    static let identifier = "FavoritesTableViewCell"

    // MARK: UI Components
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 9
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    // MARK: Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Setup
    
    private func setupConstraints() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            photoImageView.widthAnchor.constraint(equalToConstant: 100),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 1.0),
            photoImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -6),
            
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 15),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
    // MARK: Configure with Data
    
    func configure(photo: Photo) {
        nameLabel.text = photo.user.name
        photoImageView.kf.setImage(with: photo.urls.regular, placeholder: UIImage(systemName: "photo"))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        nameLabel.text = nil
    }

}
