//
//  APIError.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 29/3/25.
//

import Foundation

struct APIError: Decodable, Error {
    let errors: [String]
}
