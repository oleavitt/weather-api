//
//  DatabaseManager.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 1/1/25.
//

import SwiftData

protocol DatabaseManagerProtocol {
    associatedtype T
    func appendItem(item: T) async -> Result<T, Error>
    func removeItem(with identifier: Int) async -> Result<Void, Error>
    func fetchItems() async -> Result<[T], Error>
}

enum DatabaseError: Error {
    case itemNotFound
    case deletionFailed(String)
}

///  Manager class to provide an MVVM friendly way to perform SwiftData CRUD operations from
///  a view model vs having to be performed in a View
final class HistoryDatabaseManager : DatabaseManagerProtocol {
    typealias T = CurrentWeatherModel
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    init() {
        do {
            self.modelContainer = try ModelContainer(for: T.self) // Use T type
            self.modelContext = modelContainer.mainContext
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }
    
    func appendItem(item: T) -> Result<T, Error> {
        modelContext.insert(item)
        do {
            try modelContext.save()
            return .success(item)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchItems() -> Result<[T], Error> {
        let fetchDescriptor = FetchDescriptor<T>()
        do {
            let items = try modelContext.fetch(fetchDescriptor)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
    
    func removeItem(with id: Int) -> Result<Void, Error> {
        let fetchDescriptor = FetchDescriptor<T>()
        do {
            let items: [T] = try modelContext.fetch(fetchDescriptor)
            guard let itemToDelete = items.first(where: { $0.id == id }) else {
                return .failure(DatabaseError.itemNotFound)
            }
            modelContext.delete(itemToDelete)
            try modelContext.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
