//
//  PhotoDetailsViewModel.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 30/3/25.
//

import Combine

protocol PhotoDetailsViewModel {
    var photo: CurrentValueSubject<Photo?, Never> { get }
    
    @MainActor func getPhoto(id: String)
}

final class DefaultPhotoDetailsViewModel: PhotoDetailsViewModel {
    
    // MARK: Dependencies
    
    private let networkService: NetworkService
    
    // MARK: Properties
    
    let photo = CurrentValueSubject<Photo?, Never>(nil)
    
    // MARK: Initialization
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    // MARK: Get Photo
    
    func getPhoto(id: String) {
        Task {
            let fetchedPhoto = try? await networkService.getPhoto(id: id)
            photo.send(fetchedPhoto)
        }
    }
    
}
