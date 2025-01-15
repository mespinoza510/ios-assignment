//
//
// Created by Marco Espinoza on 1/15/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import SwiftUI

struct RecipeListView: View {
    
    @State private var recipes: [Recipe] = []
    
    var body: some View {
         NavigationView {
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
            .navigationTitle(Text("Recipes"))
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
    RecipeListView()
}


// MARK: Private custom Views
struct RecipesUnavailableView: View {
    
    var body: some View {
        VStack {
            ContentUnavailableView("No recipes found", systemImage: "text.page.badge.magnifyingglass")
        }
    }
}
