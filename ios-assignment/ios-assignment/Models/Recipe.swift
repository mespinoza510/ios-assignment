//
//
// Created by Marco Espinoza on 1/15/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import Foundation


struct RecipesResponse: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Equatable {
    let cuisine: String
    let name: String
    let uuid: String
    var photoUrlLarge: String?
    var photoUrlSmall: String?
    var sourceUrl: String?
    var youtubeUrl: String?
}
