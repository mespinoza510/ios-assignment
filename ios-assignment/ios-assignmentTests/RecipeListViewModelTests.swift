//
//
// Created by Marco Espinoza on 1/17/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import XCTest
@testable import ios_assignment


enum NetworkErrorType {
    case none
    case invalidURL
    case invalidResponse
    case decodingError
}


class MockNetworkManager: NetworkManagerProtocol {
    var errorType: NetworkErrorType = .none
    var recipesResponse: [Recipe] = []
    
    func getRecipes() async throws -> [Recipe] {
        switch errorType {
        case .none:
            return self.recipesResponse
        case .invalidURL:
            throw AppError.invalidURL
        case .invalidResponse:
            throw AppError.invalidResponse
        case .decodingError:
            throw AppError.decodingError
        }
    }
}



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
    
    func testFetchRecipesNetworkFailureThrowInvalidURLError() async {
        // Arrange: Set up the mock network manager to simulate an invalid URL error
        self.mockNetworkManager.errorType = .invalidURL
        // Act: Try to fetch recipes
        await viewModel.fetchRecipes()
        
        // Assert: Check that the recipes are not updated, loading indicator is hidden, and the alert context is set correctly
        await MainActor.run {
            XCTAssertTrue(viewModel.recipes.isEmpty, "Recipes should be empty on failure.")
            XCTAssertFalse(viewModel.isLoading, "Loading indicator should be hidden after failure.")
            
            // Check if alert context contains the expected error
            XCTAssertEqual(viewModel.alertContext.alertType?.title, AppError.invalidURL.title, "Alert title should match the network error title.")
            XCTAssertEqual(viewModel.alertContext.alertType?.message, AppError.invalidURL.message, "Alert message should match the network error message.")
        }
    }
    
    func testFetchRecipesNetworkFailureThrowInvalidResponseError() async {
        self.mockNetworkManager.errorType = .invalidResponse
        
        await viewModel.fetchRecipes()
        
        await MainActor.run {
            XCTAssertTrue(viewModel.recipes.isEmpty, "Recipes should be empty on failure.")
            XCTAssertFalse(viewModel.isLoading, "Loading indicator should be hidden after failure.")
            
            XCTAssertEqual(viewModel.alertContext.alertType?.title, AppError.invalidResponse.title, "Alert title should match the network error title.")
            XCTAssertEqual(viewModel.alertContext.alertType?.message, AppError.invalidResponse.message, "Alert message should match the network error message.")
        }
    }
    
    func testFetchRecipesNetworkFailureThrowDecodingError() async {
        self.mockNetworkManager.errorType = .decodingError
        
        await viewModel.fetchRecipes()
        
        await MainActor.run {
            XCTAssertTrue(self.viewModel.recipes.isEmpty, "Recipes should be empty on failure.")
            XCTAssertFalse(self.viewModel.isLoading, "Loading indicator should be hidden after failure.")
            
            XCTAssertEqual(self.viewModel.alertContext.alertType?.title, AppError.decodingError.title, "Alert title should match the network error title.")
            XCTAssertEqual(self.viewModel.alertContext.alertType?.message, AppError.decodingError.message, "Alert message should match the network error message.")
        }
    }
}
