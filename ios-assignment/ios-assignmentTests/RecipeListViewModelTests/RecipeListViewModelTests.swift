//
//
// Created by Marco Espinoza on 1/17/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import XCTest
@testable import ios_assignment


final class RecipeListViewModelTests: XCTestCase {
    
    var viewModel: RecipeListViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    @MainActor
    override func setUpWithError() throws {
        // Initialize the mock network manager
        self.mockNetworkManager = MockNetworkManager()
        // Inject the mock network manager into the view model
        self.viewModel = RecipeListViewModel(networkManager: mockNetworkManager)
        }
    
    override func tearDownWithError() throws {
        self.mockNetworkManager = nil
        self.viewModel = nil
    }
    
    func testFetchRecipesSuccess() async {
        // Arrange
        let mockRecipes = [
            Recipe(cuisine: "Italian", name: "Pizza", uuid: "1"),
            Recipe(cuisine: "Mexican", name: "Tacos", uuid: "2")
        ]
        
        self.mockNetworkManager.recipesResponse = mockRecipes
        
        // Act
        await self.viewModel.fetchRecipes()
        
        // Assert
        await MainActor.run {
            XCTAssertEqual(self.viewModel.recipes, mockRecipes, "The fetched recipes should match the mock recipes.")
            XCTAssertFalse(self.viewModel.isLoading, "Loading indicator should be hidden after fetching recipes.")
        }
    }
    
    func testFetchRecipesWithErrorHandling() async {
        for errorType in NetworkErrorType.allCases {
            
            self.mockNetworkManager.errorType = errorType
            
            await self.viewModel.fetchRecipes()
            
            await MainActor.run {
                XCTAssertTrue(self.viewModel.recipes.isEmpty, "Recipes should be empty on failure.")
                XCTAssertFalse(self.viewModel.isLoading, "Loading indicator should be hidden after failure.")
                
                let expectedError: AppError
                switch errorType {
                case .invalidURL:
                    expectedError = .invalidURL
                case .invalidResponse:
                    expectedError = .invalidResponse
                case .decodingError:
                    expectedError = .decodingError
                }
                
                XCTAssertEqual(self.viewModel.alertContext.alertType?.title, expectedError.title, "Alert title should match the network error title.")
                XCTAssertEqual(self.viewModel.alertContext.alertType?.message, expectedError.message, "Alert message should match the network error message.")
            }
        }
    }
}
