//
//  FavoritesViewModel.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 30/3/25.
//

import Foundation
import SwiftData
import Combine

protocol FavoritesViewModel {
    var photos: CurrentValueSubject<[Photo], Never> { get }
    
    func getPhotos() throws
}

final class DefaultFavoritesViewModel: FavoritesViewModel {
    
    // MARK: Dependencies
    
    private let modelContext: ModelContext
    
    // MARK: Initialization
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: Properties
    
    let photos = CurrentValueSubject<[Photo], Never>([])
    
    // MARK: Get Photos
    
    func getPhotos() throws {
        let descriptor = FetchDescriptor<SwiftDataPhoto>()
        let fetchedPhotos = try modelContext.fetch(descriptor)
        let photos = fetchedPhotos.map { Photo(from: $0) }
        self.photos.send(photos)
    }
    
}
