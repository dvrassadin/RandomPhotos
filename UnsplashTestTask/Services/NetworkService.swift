//
//  NetworkService.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 29/3/25.
//

import Foundation

protocol NetworkService {
    
}

actor DefaultNetworkServices: NetworkService {
    
    // MARK: Singleton
    
    static let shared = DefaultNetworkServices()
    private init() {}
    
    // MARK: Properties
    
    private let baseURL = URL(string: "https://api.unsplash.com/")
    let apiKey: String = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["UnsplashAPIKey"] as? String else {
            fatalError("Unable to get Unsplash API key from Config.plist")
        }
        return key
    }()
    
    private let session: URLSession = {
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = 15
        return session
    }()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
}
