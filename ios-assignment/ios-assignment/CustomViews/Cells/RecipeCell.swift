//
//
// Created by Marco Espinoza on 1/15/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import SwiftUI

struct RecipeCell: View {
    
    let recipe: Recipe
    
    var body: some View {
        HStack(alignment: .center, spacing: 20.0) {
            //TODO: Remove force unwrap
            if let recipeImage = self.recipe.photoUrlSmall {
                RecipeImage(image: recipeImage)
            }
            
            VStack(alignment: .leading) {
                Text(self.recipe.name)
                    .bold()
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                
                HStack(alignment: .center, spacing: 4.0) {
                    Text("Cuisine: ")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                    
                    Text(self.recipe.cuisine)
                        .font(.subheadline)
                }
            }
        }
    }
}

#Preview {
    RecipeCell(recipe: MockData.recipe)
}


// MARK: Private extracted views
private struct RecipeImage: View {
    
    let image: String
    
    var body: some View {
        AsyncImage(url: URL(string: self.image)) { image in
            image
                .resizable()
                .frame(width: 80.0, height: 80.0)
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Image(.foodPlaceholder)
                .resizable()
                .frame(width: 80.0, height: 80.0)
        }
        .clipShape(.rect(cornerRadius: 10.0, style: .circular))
        .accessibilityHidden(true)
    }
}
