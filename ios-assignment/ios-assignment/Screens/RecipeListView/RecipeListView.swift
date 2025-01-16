//
//
// Created by Marco Espinoza on 1/15/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import SwiftUI

struct RecipeListView: View {
    
    @StateObject var viewModel = RecipeListViewModel()
    
    var body: some View {
         NavigationView {
            VStack {
                if self.viewModel.isLoading {
                    ProgressView("Loading...")
                } else if self.viewModel.recipes.isEmpty {
                    RecipesUnavailableView()
                } else {
                    List {
                        ForEach(self.viewModel.recipes, id: \.uuid) { recipe in
                            NavigationLink {
                                RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe))
                            } label: {
                                RecipeCell(recipe: recipe)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(Text("Recipes"))
        }
         .alert(item: self.$viewModel.alertContext.alertType) { $0.alertItem.alert }
        .task { await self.viewModel.fetchRecipes() }
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
