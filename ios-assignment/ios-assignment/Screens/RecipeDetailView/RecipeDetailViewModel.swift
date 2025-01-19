//
//
// Created by Marco Espinoza on 1/16/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import SwiftUI


@MainActor
final class RecipeDetailViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    
    var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
