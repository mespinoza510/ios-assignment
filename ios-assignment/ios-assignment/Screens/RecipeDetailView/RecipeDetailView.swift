//
//
// Created by Marco Espinoza on 1/15/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import SwiftUI

struct RecipeDetailView: View {
    
    @StateObject var viewModel: RecipeDetailViewModel
    
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
            
            if let sourceUrl = self.viewModel.recipe.sourceUrl, let youtubeUrl = self.viewModel.recipe.youtubeUrl {
                HStack {
                    RecipeLinkView(url: sourceUrl, icon: "network", color: .green, accessibilityLabel: "Recipe Source")
                    
                    RecipeLinkView(url: youtubeUrl, icon: "play.fill", color: .red, accessibilityLabel: "Youtube Video")
                }
                .padding(EdgeInsets(top: 10.0, leading: 20.0, bottom: 10.0, trailing: 20.0))
                .background(Color(.secondarySystemBackground))
                .clipShape(.capsule)
            }
            
            Spacer()
        }
        .navigationTitle(self.viewModel.recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        RecipeDetailView(viewModel: RecipeDetailViewModel(recipe: MockData.recipe))
    }
}


fileprivate struct RecipeBannerView: View {
    
    let image: String
    
    var body: some View {
        AsyncImage(url: URL(string: self.image)) { image in
            image
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: 300.0)
                .scaledToFill()
                
        } placeholder: {
            Image(.foodPlaceholder)
                .resizable()
                .frame(height: 300.0)
                .scaledToFill()
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
    
    var body: some View {
        HStack {
            Link(destination: URL(string: self.url)!) {
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
        }
        .accessibilityLabel(self.accessibilityLabel)
    }
}
