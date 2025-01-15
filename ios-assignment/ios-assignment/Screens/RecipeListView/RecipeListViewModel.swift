//
//
// Created by Marco Espinoza on 1/15/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import SwiftUI


@MainActor
final class RecipeListViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var recipes: [Recipe] = []
    
    func fetchRecipes() async {
        self.showLoadingView()
        
        do {
            self.recipes = try await NetworkManager.shared.getRecipes()
            self.hideLoadingView()
        } catch {
            // handle error
        }
    }
    
    // MARK: - Loading state handlers
    private func showLoadingView() {
        self.isLoading = true
    }
    
    private func hideLoadingView() {
        self.isLoading = false
    }
}
