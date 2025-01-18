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
    @Published var recipes: [Recipe] = []
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchRecipes() async {
        self.showLoadingView()
        
        do {
            self.recipes = try await self.networkManager.getRecipes()
            self.hideLoadingView()
        } catch let error as AppError {
            self.hideLoadingView()
            self.alertContext.showAlert(error)
        } catch {
            self.hideLoadingView()
            self.alertContext.showAlert(.decodingError)
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
