//
//  SwiftDataPhoto.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 30/3/25.
//

import Foundation
import SwiftData

@Model
final class SwiftDataPhoto {
    @Attribute(.unique) var unsplashID: String
    var createdAt: Date
    var downloads: Int?

    @Relationship var location: SwiftDataLocation?
    @Relationship var urls: SwiftDataPhotoURLs
    @Relationship var user: SwiftDataUser

    init(
        unsplashID: String,
        createdAt: Date,
        downloads: Int? = nil,
        location: SwiftDataLocation? = nil,
        urls: SwiftDataPhotoURLs,
        user: SwiftDataUser
    ) {
        self.unsplashID = unsplashID
        self.createdAt = createdAt
        self.downloads = downloads
        self.location = location
        self.urls = urls
        self.user = user
    }
    
    init(from photo: Photo) {
        self.unsplashID = photo.id
        self.createdAt = photo.createdAt
        self.downloads = photo.downloads
        self.location = SwiftDataLocation(from: photo.location)
        self.urls = SwiftDataPhotoURLs(regular: photo.urls.regular)
        self.user = SwiftDataUser(name: photo.user.name)
    }
    
}

// Вынесенные модели
@Model
final class SwiftDataPhotoURLs {
    var regular: URL
    
    init(regular: URL) {
        self.regular = regular
    }
}

@Model
final class SwiftDataUser {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

@Model
final class SwiftDataLocation {
    var city: String?
    var country: String?
    
    init(city: String? = nil, country: String? = nil) {
        self.city = city
        self.country = country
    }
    
    init(from location: Photo.Location?) {
        self.city = location?.city
        self.country = location?.country
    }
    
}
