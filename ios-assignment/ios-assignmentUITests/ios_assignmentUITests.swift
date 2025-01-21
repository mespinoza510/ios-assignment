//
//
// Created by Marco Espinoza on 1/15/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import XCTest

final class RecipeListUITests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        self.app = XCUIApplication()
        self.app.launch()
        
        // Stop test immediately when failure occurs
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        self.app.terminate()
        self.app = nil
    }

    @MainActor
    func testNavigationTitleIsDisplayed() throws {
        let navigationTitleElement = app.navigationBars["Recipes"].firstMatch
        XCTAssertTrue(navigationTitleElement.exists, "Navigation title 'Recipes' should be displayed.")
    }
    
    @MainActor
    func testFirstCellTitleIsDisplayed() throws {
        let firstCell = self.app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 1), "First cell did not appear in time.")
        
        // Verify all static texts exist in first cell
        let recipeNameLabel = firstCell.staticTexts["RecipeNameLabel"]
        let cuisineLabel = firstCell.staticTexts["CuisineLabel"]
        let recipeDesciptionLabel = firstCell.staticTexts["RecipeDescriptionLabel"]
        
        XCTAssertTrue(recipeNameLabel.exists, "RecipeNameLabel does not exist in the first cell")
        XCTAssertTrue(cuisineLabel.exists, "CuisineLabel does not exist in the first cell")
        XCTAssertTrue(recipeDesciptionLabel.exists, "RecipeDescriptionLabel does not exist in the first cell")
    }
    
    @MainActor
    func testLoadMoreRecipesButtonIsDisplayed() throws {
        let list = self.app.collectionViews.firstMatch
        let firstCell = self.app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 1), "First cell did not appear in time.")
        
        self.swipeUpToLoadMoreButton(in: list)
        
        XCTAssertTrue(self.doesLoadMoreButtonExist, "Load more recipes button does not exist")
    }
    
    //MARK: - private helper methods and properties
    private var doesLoadMoreButtonExist: Bool {
        return self.app.buttons["LoadMoreButton"].exists
    }
    
    private func swipeUp(in list: XCUIElement) {
        list.swipeUp()
    }
    
    private func swipeUpToLoadMoreButton(in list: XCUIElement) {
        while !self.doesLoadMoreButtonExist {
            self.swipeUp(in: list)
        }
    }
}
