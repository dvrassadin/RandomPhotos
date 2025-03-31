//
//  ModelContextProvider.swift
//  UnsplashTestTask
//
//  Created by Daniil Rassadin on 30/3/25.
//

import Foundation
import SwiftData

@MainActor
final class ModelContextProvider {
    static let shared = ModelContextProvider()
    
    private let container: ModelContainer
    var context: ModelContext { container.mainContext }
    
    private init() {
        do {
            container = try ModelContainer(for: SwiftDataPhoto.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}

