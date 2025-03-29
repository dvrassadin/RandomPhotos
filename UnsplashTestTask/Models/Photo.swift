//
//  Photo.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 29/3/25.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let urls: PhotoURLs
    
    struct PhotoURLs: Decodable {
        let regular: URL
    }
}
