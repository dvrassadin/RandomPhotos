//
//  Photo.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 29/3/25.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let createdAt: Date
    let downloads: Int?
    let location: Location?
    let urls: PhotoURLs
    let user: User
    
    struct PhotoURLs: Decodable {
        let regular: URL
    }
    
    struct User: Decodable {
        let name: String
    }
    
    struct Location: Decodable {
        let city: String?
        let country: String?
        
        init(from swiftDataPhoto: SwiftDataLocation?) {
            self.city = swiftDataPhoto?.city
            self.country = swiftDataPhoto?.country
        }
    }
    
    init(from swiftDataPhoto: SwiftDataPhoto) {
        self.id = swiftDataPhoto.unsplashID
        self.createdAt = swiftDataPhoto.createdAt
        self.downloads = swiftDataPhoto.downloads
        self.location = Location(from: swiftDataPhoto.location)
        self.urls = PhotoURLs(regular: swiftDataPhoto.urls.regular)
        self.user = User(name: swiftDataPhoto.user.name)
    }
}
