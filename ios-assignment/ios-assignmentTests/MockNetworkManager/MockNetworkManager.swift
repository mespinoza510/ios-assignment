//
//
// Created by Marco Espinoza on 1/18/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

@testable import ios_assignment


enum NetworkErrorType: CaseIterable {
    case invalidURL
    case invalidResponse
    case decodingError
}


class MockNetworkManager: NetworkManagerProtocol {
    var errorType: NetworkErrorType?
    var recipesResponse: [Recipe] = []
    
    func getRecipes() async throws -> [Recipe] {
        if let errorType = self.errorType {
            switch errorType {
            case .invalidURL:
                throw AppError.invalidURL
            case .invalidResponse:
                throw AppError.invalidResponse
            case .decodingError:
                throw AppError.decodingError
            }
        }
        
        return self.recipesResponse
    }
}
