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
        
        XCTAssertTrue(firstCell.recipeNameLabel.exists, "RecipeNameLabel does not exist in the first cell")
        XCTAssertTrue(firstCell.cuisineLabel.exists, "CuisineLabel does not exist in the first cell")
        XCTAssertTrue(firstCell.recipeDescriptionLabel.exists, "RecipeDescriptionLabel does not exist in the first cell")
    }
    
    @MainActor
    func testSwipeDownUntilLoadMoreRecipesButtonIsDisplayed() throws {
        let list = self.app.collectionViews.firstMatch
        let firstCell = self.app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 1), "First cell did not appear in time.")
        
        self.swipeUpToLoadMoreButton(in: list)
        
        XCTAssertTrue(self.app.loadMoreButton.exists, "Load more recipes button does not exist")
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
        XCTAssertFalse(self.app.loadMoreButton.exists, "Load more button should not exist after loading the whole list")
        XCTAssertEqual(lastRecipeCell.recipeNameLabel.label, "White Chocolate Crème Brûlée", "Expected last cell to be 'White Chocolate Crème Brûlée'")
    }
}


extension XCUIElement {
    var recipeNameLabel: XCUIElement {
        return self.staticTexts["RecipeNameLabel"]
    }
    
    var cuisineLabel: XCUIElement {
        return self.staticTexts["CuisineLabel"]
    }
    
    var recipeDescriptionLabel: XCUIElement {
        return self.staticTexts["RecipeDescriptionLabel"]
    }
    
    var loadMoreButton: XCUIElement {
        return self.buttons["LoadMoreButton"]
    }
}
