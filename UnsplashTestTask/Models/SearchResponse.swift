//
//  SearchResponse.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 30/3/25.
//

import Foundation

struct SearchResponse: Decodable {
    let totalPages: Int
    let results: [Photo]
}
