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
    
    func testPaginationSuccess() async {
        let mockRecipes = (1...26).map { Recipe(cuisine: "cuisine", name: "\($0)", uuid: "\($0)")}
        
        self.mockNetworkManager.recipesResponse = mockRecipes
        
        await self.viewModel.fetchAllRecipes(isRefresh: false)
        
        await MainActor.run {
            XCTAssertEqual(self.viewModel.visibleRecipes.count, 25, "There should be two visible recipes after the first fetch.")
        }
        
        await self.viewModel.loadNextPage()
        
        await MainActor.run {
            XCTAssertEqual(self.viewModel.visibleRecipes.count, 26, "There should be four visible recipes after loading the next page.")
            XCTAssertEqual(self.viewModel.allRecipes.count, 0, "All recipes should be empty after loading all the available recipes.")
        }
    }
    
    func testPaginationWithFewerThanPageSizeRecipes() async {
        let mockRecipes = (1...10).map { Recipe(cuisine: "cuisine", name: "\($0)", uuid: "\($0)")}

        self.mockNetworkManager.recipesResponse = mockRecipes
        
        await self.viewModel.fetchAllRecipes(isRefresh: false)
        
        await MainActor.run {
            XCTAssertEqual(self.viewModel.visibleRecipes.count, 10, "There should be four visible recipes after loading the next page.")
            XCTAssertEqual(self.viewModel.allRecipes.count, 0, "All recipes should be empty after loading all the available recipes.")
        }
    }
    
    func testPaginationWithExactlyPageSizeRecipes() async {
        let mockRecipes = (1...25).map { Recipe(cuisine: "cuisine", name: "\($0)", uuid: "\($0)")}
        
        self.mockNetworkManager.recipesResponse = mockRecipes
        
        await self.viewModel.fetchAllRecipes(isRefresh: false)
        
        await MainActor.run {
            XCTAssertEqual(self.viewModel.visibleRecipes.count, 25, "There should be 25 visible recipes after the first fetch.")
        }
        
        await self.viewModel.loadNextPage()
        
        await MainActor.run {
            XCTAssertEqual(self.viewModel.visibleRecipes.count, 25, "There should be four visible recipes after loading the next page.")
            XCTAssertEqual(self.viewModel.allRecipes.count, 0, "All recipes should be empty after loading all the available recipes.")
        }
    }
    
    func testPaginationWithRefreshEnabled() async {
        let mockRecipes = (1...30).map { Recipe(cuisine: "cuisine", name: "\($0)", uuid: "\($0)")}
        
        self.mockNetworkManager.recipesResponse = mockRecipes
        
        await self.viewModel.fetchAllRecipes(isRefresh: false)
        
        await MainActor.run {
            XCTAssertEqual(self.viewModel.visibleRecipes.count, 25, "There should be 25 visible recipes after the first fetch.")
        }
        
        await self.viewModel.loadNextPage()
        
        await MainActor.run {
            XCTAssertEqual(self.viewModel.visibleRecipes.count, 30, "There should be four visible recipes after loading the next page.")
            XCTAssertEqual(self.viewModel.allRecipes.count, 0, "All recipes should be empty after loading all the available recipes.")
        }
        
        await self.viewModel.fetchAllRecipes(isRefresh: true)
        
        await MainActor.run {
            XCTAssertEqual(self.viewModel.visibleRecipes.count, 25, "There should be 25 visible recipes after the first fetch.")
            XCTAssertEqual(self.viewModel.allRecipes.count, 5, "All recipes should have 5 items after refreshing.")
        }
    }
    
    func testFetchRecipesSuccess() async {
        let mockRecipes = [
            Recipe(cuisine: "Italian", name: "Pizza", uuid: "1"),
            Recipe(cuisine: "Mexican", name: "Tacos", uuid: "2")
        ]
        
        self.mockNetworkManager.recipesResponse = mockRecipes
        
        // invoke mock request
        await self.viewModel.fetchAllRecipes()
        
        // Assert
        await MainActor.run {
            XCTAssertEqual(self.viewModel.visibleRecipes, mockRecipes, "The fetched recipes should match the mock recipes.")
            XCTAssertFalse(self.viewModel.isLoading, "Loading indicator should be hidden after fetching recipes.")
        }
    }
    
    func testFetchRecipesWithErrorHandling() async {
        for errorType in NetworkErrorType.allCases {
            
            self.mockNetworkManager.errorType = errorType
            
            await self.viewModel.fetchAllRecipes()
            
            await MainActor.run {
                XCTAssertTrue(self.viewModel.allRecipes.isEmpty, "Recipes should be empty on failure.")
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
