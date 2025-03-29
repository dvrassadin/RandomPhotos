//
//  NetworkService.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 29/3/25.
//

import Foundation

protocol NetworkService {
    func getPhotos() async throws -> [Photo]
}

actor DefaultNetworkServices: NetworkService {
    
    // MARK: Singleton
    
    static let shared = DefaultNetworkServices()
    private init() {}
    
    // MARK: Properties
    
    private let baseURL: URL = {
        guard let url = URL(string: "https://api.unsplash.com/") else {
            fatalError("Invalid base URL")
        }
        return url
    }()
        
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
        session.configuration.timeoutIntervalForRequest = 10
        return session
    }()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private lazy var unknownError = APIError(errors: [String(localized: "Something went wrong")])
    
    // MARK: Decode Error
    
    private func decodeError(from data: Data) -> APIError {
        guard let errorMessage = try? decoder.decode(APIError.self, from: data).errors.first else  {
            return unknownError
        }
        return APIError(errors: [errorMessage])
    }
    
    // MARK: Get Photos
    
    func getPhotos() async throws -> [Photo] {
        let url = baseURL
            .appendingPathComponent("photos")
            .appending(
                queryItems: [
                    URLQueryItem(name: "client_id", value: apiKey),
                    URLQueryItem(name: "per_page", value: "15")
                ]
            )
        
        let (data, _) = try await session.data(from: url)
        
        do {
            return try decoder.decode([Photo].self, from: data)
        } catch {
            throw decodeError(from: data)
        }
    }
    
}
