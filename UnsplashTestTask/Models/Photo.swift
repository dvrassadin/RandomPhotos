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
    }
}
