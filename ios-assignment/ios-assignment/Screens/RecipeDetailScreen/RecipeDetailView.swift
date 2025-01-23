//
//
// Created by Marco Espinoza on 1/15/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import SwiftUI

struct RecipeDetailView: View {
    
    @StateObject var viewModel: RecipeDetailViewModel
    @State private var urlToOpen: String? = nil
    
    var body: some View {
        VStack {
            if let photoUrlLarge = self.viewModel.recipe.photoUrlLarge {
                RecipeBannerView(image: photoUrlLarge)
            }
            
            Text("Cuisine: \(self.viewModel.recipe.cuisine)")
                .lineLimit(1)
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text("Resources for recipe")
                .font(.title2)
                .lineLimit(1)
                .padding(.top)
            
            RecipeSourcesView(urlToOpen: self.$urlToOpen, sourceUrl: self.viewModel.recipe.sourceUrl, youtubeUrl: self.viewModel.recipe.youtubeUrl)
            
            Spacer()
        }
        .navigationTitle(self.viewModel.recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .openSafari(url: self.$urlToOpen)
    }
}

#Preview {
    NavigationView {
        RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: MockData.recipe))
    }
}

// MARK: - Private custom views
fileprivate struct RecipeBannerView: View {
    
    let image: String
    
    var body: some View {
        AsyncImage(url: URL(string: self.image)) { image in
            image
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: 300.0)
                .scaledToFill()
                .accessibilityIdentifier("recipeLargeImageRendered")
                
        } placeholder: {
            Image(.foodPlaceholder)
                .resizable()
                .frame(height: 300.0)
                .scaledToFill()
                .accessibilityIdentifier("recipeLargeImagePlaceholder")
        }
        .accessibilityHidden(true)
        .padding(.top)
    }
}


fileprivate struct RecipeLinkView: View {
    
    let url: String
    let icon: String
    let color: Color
    let accessibilityLabel: String
    
    @Binding var urlToOpen: String?
    
    var body: some View {
        Button {
            self.urlToOpen = self.url
        } label: {
            ZStack {
                Circle()
                    .foregroundStyle(self.color)
                    .frame(width: 60, height: 60)
                
                Image(systemName: self.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(.white)
            }
        }
        .accessibilityLabel(self.accessibilityLabel)
    }
}


fileprivate struct RecipeSourcesView: View {
    @Binding var urlToOpen: String?
    
    var sourceUrl: String?
    var youtubeUrl: String?
    
    var body: some View {
        HStack {
            if let sourceUrl = self.sourceUrl {
                RecipeLinkView(url: sourceUrl, icon: "network", color: .green, accessibilityLabel: "Recipe Source", urlToOpen: self.$urlToOpen)
                    .accessibilityIdentifier("sourceButton")
            }
            
            if let youtubeUrl = self.youtubeUrl {
                RecipeLinkView(url: youtubeUrl, icon: "play.fill", color: .red, accessibilityLabel: "Recipe YouTube", urlToOpen: self.$urlToOpen)
                    .accessibilityIdentifier("youtubeButton")
            }
            
            if sourceUrl == nil && youtubeUrl == nil {
                Text("No sources available for this recipe")
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
        .padding(EdgeInsets(top: 10.0, leading: 20.0, bottom: 10.0, trailing: 20.0))
        .background(Color(.secondarySystemBackground))
        .clipShape(.capsule)
    }
}


