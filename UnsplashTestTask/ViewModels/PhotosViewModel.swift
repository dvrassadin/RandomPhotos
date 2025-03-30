//
//  PhotosViewModel.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 29/3/25.
//

import Foundation
import Combine

protocol PhotosViewModel {
    var photos: CurrentValueSubject<[Photo], Never> { get }
    var isLoading: PassthroughSubject<Bool, Never> { get }
    var errorMessage: PassthroughSubject<String, Never> { get }
    
    @MainActor func getPhotos()
    @MainActor func searchPhotos(query: String)
}

final class DefaultPhotosViewModel: PhotosViewModel {
    
    // MARK: Dependencies
    
    private let networkService: NetworkService
    
    // MARK: Properties
    
    private let itemsPerPage: UInt = 20 // For pagination
    
    let photos = CurrentValueSubject<[Photo], Never>([])
    let isLoading = PassthroughSubject<Bool, Never>()
    let errorMessage = PassthroughSubject<String, Never>()
    
    // MARK: Initialization
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    // MARK: Get Photos
    
    func getPhotos() {
        isLoading.send(true)
        Task {
            do {
                let fetchedPhotos = try await networkService.getPhotos(
                    page: 1,
                    perPage: itemsPerPage
                )
                isLoading.send(false)
                photos.send(fetchedPhotos)
            } catch {
                isLoading.send(false)
                if let error = (error as? APIError)?.errors.first {
                    errorMessage.send(error)
                } else {
                    errorMessage.send(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: Search Photos
    
    func searchPhotos(query: String) {
        Task {
            isLoading.send(true)
            do {
                let response = try await networkService.searchPhotos(
                    query: query,
                    page: 1,
                    perPage: itemsPerPage
                )
                isLoading.send(false)
                photos.send(response.results)
            } catch {
                isLoading.send(false)
                if let error = (error as? APIError)?.errors.first {
                    errorMessage.send(error)
                } else {
                    errorMessage.send(error.localizedDescription)
                }
            }
        }
    }
    
}
