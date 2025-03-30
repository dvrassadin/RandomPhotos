//
//  NetworkService.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 29/3/25.
//

import OSLog

protocol NetworkService {
    func getPhotos(page: UInt, perPage: UInt) async throws -> [Photo]
    func searchPhotos(query: String, page: UInt, perPage: UInt) async throws -> SearchResponse
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
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: "Networking"
    )
    
    // MARK: Decode Error
    
    private func decodeError(from data: Data, url: URL) -> APIError {
        guard let errorMessage = try? decoder.decode(APIError.self, from: data).errors.first else  {
            logger.error("Decoding error for request: \(url.absoluteString)")
            return unknownError
        }
        return APIError(errors: [errorMessage])
    }
    
    // MARK: Get Photos
    
    func getPhotos(page: UInt, perPage: UInt) async throws -> [Photo] {
        let url = baseURL
            .appendingPathComponent("photos")
            .appending(
                queryItems: [
                    URLQueryItem(name: "client_id", value: apiKey),
                    URLQueryItem(name: "page", value: String(page)),
                    URLQueryItem(name: "per_page", value: String(perPage))
                ]
            )
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, _) = try await session.data(from: url)
        
        do {
            let photos = try decoder.decode([Photo].self, from: data)
            logger.info("Received \(photos.count) photos for request: \(url.absoluteString)")
            return photos
        } catch {
            throw decodeError(from: data, url: url)
        }
    }
    
    // MARK: Search Photos
    
    func searchPhotos(query: String, page: UInt, perPage: UInt) async throws -> SearchResponse {
        let url = baseURL
            .appendingPathComponent("search")
            .appendingPathComponent("photos")
            .appending(
                queryItems: [
                    URLQueryItem(name: "client_id", value: apiKey),
                    URLQueryItem(name: "query", value: query),
                    URLQueryItem(name: "page", value: String(page)),
                    URLQueryItem(name: "per_page", value: String(perPage))
                ]
            )
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, _) = try await session.data(from: url)
        
        do {
            let response = try decoder.decode(SearchResponse.self, from: data)
            logger.info("Received \(response.results.count) photos for request: \(url.absoluteString)")
            return response
        } catch {
            throw decodeError(from: data, url: url)
        }
    }
    
}
