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
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if viewModel.visibleRecipes.isEmpty {
                    RecipesUnavailableView()
                } else {
                    List {
                        ForEach(viewModel.visibleRecipes, id: \.uuid) { recipe in
                            NavigationLink {
                                RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: recipe))
                            } label: {
                                RecipeCell(recipe: recipe)
                            }
                        }
                        RefreshButtonView(viewModel: self.viewModel)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await self.viewModel.fetchAllRecipes(isRefresh: true)
                    }
                }
            }
            .navigationTitle(Text("Recipes"))
        }
        .alert(item: $viewModel.alertContext.alertType) { $0.alertItem.alert }
        .task { await viewModel.fetchAllRecipes() }
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

struct RefreshButtonView: View {
    @ObservedObject var viewModel: RecipeListViewModel
    
    var body: some View {
        if !self.viewModel.allRecipes.isEmpty && !self.viewModel.isLoading && !self.viewModel.isRefreshing {
            HStack  {
                Spacer()
                Button {
                    self.viewModel.loadNextPage()
                } label: {
                    Text("Load More")
                        .foregroundStyle(.blue)
                }
                .accessibilityAddTraits(.isButton)
                .accessibilityIdentifier("loadMoreButton")
                Spacer()
            }
        }
    }
}
