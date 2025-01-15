//
//
// Created by Marco Espinoza on 1/15/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import SwiftUI

class NetworkManager {
    static let shared = NetworkManager()
    
    private let endpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    private let decoder = JSONDecoder()
    
    private init() {
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func getRecipes() async throws -> [Recipe] {
        guard let url = URL(string: self.endpoint) else {
            throw AppError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw AppError.invalidResponse
        }
        
        let recipesResponse = try self.decoder.decode(RecipesResponse.self, from: data)
        return recipesResponse.recipes
    }
}
