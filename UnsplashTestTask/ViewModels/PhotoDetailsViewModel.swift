//
//  PhotoDetailsViewModel.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 30/3/25.
//

import Foundation
import Combine
import SwiftData

protocol PhotoDetailsViewModel {
    var photo: CurrentValueSubject<Photo?, Never> { get }
    
    @MainActor func getPhoto(id: String)
    @MainActor func isPhotoFavoritePhoto(id: String) -> Bool
    @MainActor func addToFavorites(photo: Photo) throws
    @MainActor func removeFromFavorites(id: String) throws
}

final class DefaultPhotoDetailsViewModel: PhotoDetailsViewModel {
    
    // MARK: Dependencies
    
    private let networkService: NetworkService
    private let modelContext: ModelContext
    
    // MARK: Properties
    
    let photo = CurrentValueSubject<Photo?, Never>(nil)
    
    
    // MARK: Initialization
    
    init(networkService: NetworkService, modelContext: ModelContext) {
        self.networkService = networkService
        self.modelContext = modelContext
    }
    
    // MARK: Get Photo
    
    func getPhoto(id: String) {
        Task {
            let fetchedPhoto = try? await networkService.getPhoto(id: id)
            photo.send(fetchedPhoto)
        }
    }
    
    // MARK: SwiftData Methods
    
    func isPhotoFavoritePhoto(id: String) -> Bool {
        let predicate = #Predicate<SwiftDataPhoto> { $0.unsplashID == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        return (try? modelContext.fetch(descriptor).first) != nil
    }
    
    func addToFavorites(photo: Photo) throws {
        let swiftDataPhoto = SwiftDataPhoto(from: photo)
        ModelContextProvider.shared.context.insert(swiftDataPhoto)
        try modelContext.save()
        NotificationCenter.default.post(name: .photosDidChange, object: nil)
    }
    
    func removeFromFavorites(id: String) throws {
        let predicate = #Predicate<SwiftDataPhoto> { $0.unsplashID == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        let photos = try modelContext.fetch(descriptor)
        photos.forEach { modelContext.delete($0) }
        NotificationCenter.default.post(name: .photosDidChange, object: nil)
    }
    
}
