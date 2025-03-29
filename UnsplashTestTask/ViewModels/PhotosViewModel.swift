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
}

final class DefaultPhotosViewModel: PhotosViewModel {
    
    // MARK: Dependencies
    
    private let networkService: NetworkService
    
    
    // MARK: Properties
    
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
                let fetchedPhotos = try await networkService.getPhotos()
                isLoading.send(false)
                photos.send(fetchedPhotos)
            } catch {
                isLoading.send(false)
                errorMessage.send(error.localizedDescription)
            }
        }
    }
    
}
