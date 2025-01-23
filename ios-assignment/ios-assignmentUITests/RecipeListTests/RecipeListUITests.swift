//
//
// Created by Marco Espinoza on 1/15/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import XCTest


final class RecipeListUITests: BaseUITest {

    @MainActor
    func testNavigationTitleIsDisplayed() throws {
        let navigationTitleElement = app.navigationBars["Recipes"].firstMatch
        XCTAssertTrue(navigationTitleElement.exists, "Navigation title 'Recipes' should be displayed.")
    }
    
    @MainActor
    func testFirstCellTitleIsDisplayed() throws {
        let firstCell = self.waitForCell(at: 0)
        
        self.assertElementExists(.recipeNameLabel, in: firstCell)
        self.assertElementExists(.cuisineLabel, in: firstCell)
        self.assertElementExists(.recipeDescriptionLabel, in: firstCell)
    }
    
    @MainActor
    func testSwipeDownUntilLoadMoreRecipesButtonIsDisplayed() throws {
        let list = self.app.collectionViews.firstMatch
        let firstCell = self.app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 1), "First cell did not appear in time.")
        
        self.swipeUpToLoadMoreButton(in: list)
        self.assertElementExists(.loadMoreButton)
    }
    
    @MainActor
    func testLoadEntireListAndAssertLastCell() throws {
        let list = self.app.collectionViews.firstMatch
        
        self.swipeUpToLoadMoreButton(in: list)
        self.tapLoadMoreButton()
        self.swipeUpToLoadMoreButton(in: list)
        self.tapLoadMoreButton()
        self.swipeToBottom(of: list)
        
        guard let lastRecipeCell = list.cells.allElementsBoundByIndex.last else {
            XCTFail("No cells found in the list")
            return
        }
        
        // Assert last cell of list and ensure 'Load More' button does not exist
        XCTAssertFalse(self.app.element(for: .loadMoreButton).exists, "Load more button should not exist after loading the whole list")
        XCTAssertEqual(lastRecipeCell.element(for: .recipeNameLabel).label, "White Chocolate Crème Brûlée", "Expected last cell to be 'White Chocolate Crème Brûlée'")
    }
}
