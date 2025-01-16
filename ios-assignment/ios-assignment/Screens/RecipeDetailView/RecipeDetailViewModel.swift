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
    
    //TODO: error handling for links that do not work ie. youtube url and sourceUrl
}
