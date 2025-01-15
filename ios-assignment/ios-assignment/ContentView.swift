//
//
// Created by Marco Espinoza on 1/15/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import SwiftUI

struct ContentView: View {
    
    @State private var recipes: [Recipe] = []
    
    var body: some View {
        VStack {
            if self.recipes.isEmpty {
                RecipesUnavailableView()
            } else {
                List {
                    ForEach(self.recipes, id: \.uuid) { recipe in
                        RecipeCell(recipe: recipe)
                    }
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            Task {
                let recipes = try await NetworkManager.shared.getRecipes()
                self.recipes = recipes
                print("Recipes: \(recipes.count)")
            }
        }
    }
}

#Preview {
    ContentView()
}


// MARK: Private custom Views
struct RecipesUnavailableView: View {
    
    var body: some View {
        VStack {
            ContentUnavailableView("No recipes found", systemImage: "text.page.badge.magnifyingglass")
        }
    }
}
