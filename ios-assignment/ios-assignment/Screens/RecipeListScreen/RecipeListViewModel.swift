//
//
// Created by Marco Espinoza on 1/15/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import SwiftUI


@MainActor
final class RecipeListViewModel: ObservableObject {
    
    @Published var alertContext = AlertContext()
    @Published var isLoading: Bool = false
    @Published var isRefreshing: Bool = false
    @Published var allRecipes: [Recipe] = []
    @Published var visibleRecipes: [Recipe] = []
    
    private let pageSize: Int = 25
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    /// fetch all recipes with option to refresh
    func fetchAllRecipes(isRefresh: Bool = false) async {
        if isRefresh {
            self.visibleRecipes.removeAll()
            self.isRefreshing = true
        } else {
            self.showLoadingView()
        }
        
        do {
            let fetchedRecipes = try await networkManager.getRecipes()
            self.allRecipes = fetchedRecipes
            // Add the first batch of recipes to visibleRecipes
            self.appendVisibleRecipes(from: self.allRecipes)
        } catch let error as AppError {
            self.hideLoadingView()
            self.alertContext.showAlert(error)
        } catch {
            self.hideLoadingView()
            self.alertContext.showAlert(.decodingError)
        }
        self.hideLoadingView()
        self.isRefreshing = false
    }
    
    func loadNextPage() {
        guard !self.isLoading, !self.allRecipes.isEmpty else { return } // Prevent loading during an active load

        // Determine the number of items to load
        let recipesToLoad = min(pageSize, allRecipes.count)

        // Extract the next set of recipes and ensure uniqueness
        let nextBatch = self.allRecipes.prefix(recipesToLoad)
        let uniqueBatch = nextBatch.filter { !self.visibleRecipes.contains($0) }
        
        // update visible and remaining recipes
        self.visibleRecipes.append(contentsOf: uniqueBatch)
        self.allRecipes.removeFirst(recipesToLoad)
    }
    
    private func resetData() {
        self.allRecipes.removeAll()
        self.visibleRecipes.removeAll()
    }
    
    private func appendVisibleRecipes(from recipes: [Recipe]) {
        let initialBatch = recipes.prefix(self.pageSize)
        self.visibleRecipes.append(contentsOf: initialBatch)
        self.allRecipes = Array(recipes.dropFirst(self.pageSize))
    }
    
    // MARK: - Loading state handlers
    private func showLoadingView() {
        self.isLoading = true
    }
    
    private func hideLoadingView() {
        self.isLoading = false
    }
}
