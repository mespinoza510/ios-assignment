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
        let firstCell = self.waitForCell(at: 0)
        
        // Verify all static texts exist in first cell
        let recipeNameLabel = firstCell.recipeNameLabel
        let cuisineLabel = firstCell.cuisineLabel
        let recipeDesciptionLabel = firstCell.recipeDescriptionLabel
        
        XCTAssertTrue(recipeNameLabel.exists, "RecipeNameLabel does not exist in the first cell")
        XCTAssertTrue(cuisineLabel.exists, "CuisineLabel does not exist in the first cell")
        XCTAssertTrue(recipeDesciptionLabel.exists, "RecipeDescriptionLabel does not exist in the first cell")
    }
    
    @MainActor
    func testSwipeDownUntilLoadMoreRecipesButtonIsDisplayed() throws {
        let list = self.app.collectionViews.firstMatch
        let firstCell = self.app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 1), "First cell did not appear in time.")
        
        self.swipeUpToLoadMoreButton(in: list)
        
        XCTAssertTrue(self.doesLoadMoreButtonExist, "Load more recipes button does not exist")
    }
    
    @MainActor
    func testLoadEntireListAndAssertLastCell() throws {
        let list = self.app.collectionViews.firstMatch
        let loadMoreButton = self.app.loadMoreButton
        
        self.swipeUpToLoadMoreButton(in: list)
        XCTAssertTrue(loadMoreButton.exists, "Load more button does not exist")

        // Press load more button and continue scrolling
        self.tapLoadMoreButton()
        self.swipeUpToLoadMoreButton(in: list)

        XCTAssertTrue(loadMoreButton.exists, "Load more button does not exist")
        self.tapLoadMoreButton()
        
        self.swipeToBottom(of: list)
        
        guard let lastRecipeCell = list.cells.allElementsBoundByIndex.last else {
            XCTFail("No cells found in the list")
            return
        }
        
        let lastCellLabel = lastRecipeCell.recipeNameLabel.label
        
        // Assert last cell of list and ensure 'Load More' button does not exist
        XCTAssertFalse(loadMoreButton.exists, "Load more button should not exist after loading the whole list")
        XCTAssertEqual(lastCellLabel, "White Chocolate Crème Brûlée", "Expected last cell to be 'White Chocolate Crème Brûlée'")
    }
    
    //MARK: - private helper methods and properties
    private var doesLoadMoreButtonExist: Bool {
        return self.app.loadMoreButton.exists
    }
    
    private func swipeUp(in list: XCUIElement) {
        list.swipeUp()
    }
    
    private func swipeToBottom(of list: XCUIElement) {
        let lastVisibleCell = self.getLastVisibleCell(in: list) // get last visible cell at top most hierarchy
        var lastVisibleLabel = self.getCombinedLabel(from: lastVisibleCell) // descend hierarchy to get labels
        
        while lastVisibleCell.isHittable {
            list.swipeUp()
            sleep(1) // wait for scroll to stop
            let updatedLastVisibleCell = self.getLastVisibleCell(in: list)
            
            let updatedLastVisibleLabel = self.getCombinedLabel(from: updatedLastVisibleCell)
            if lastVisibleLabel == updatedLastVisibleLabel {
                break
            }
            lastVisibleLabel = updatedLastVisibleLabel // update label of bottom-most cell that is visible
        }
    }
    
    private func swipeUpToLoadMoreButton(in list: XCUIElement) {
        while !self.doesLoadMoreButtonExist {
            self.swipeUp(in: list)
        }
    }
    
    private func waitForCell(at index: Int, timeout: TimeInterval = 1) -> XCUIElement {
        let cell = self.app.cells.element(boundBy: index)
        XCTAssertTrue(cell.waitForExistence(timeout: timeout), "Cell \(index) did not appear in time.")
        return cell
    }
    
    private func tapLoadMoreButton() {
        let button = self.app.loadMoreButton
        button.tap()
    }
    
    /// returns bottom most visible cell of list
    private func getLastVisibleCell(in list: XCUIElement) -> XCUIElement {
        let cells = list.cells
        let lastVisibleCellIndex = cells.count - 1
        return cells.element(boundBy: lastVisibleCellIndex)
    }
    
    /// concatenates the string of the cell label
    private func getCombinedLabel(from cell: XCUIElement) -> String {
        let recipeNameLabel = self.getLabelDescription(from: cell, with: "RecipeNameLabel")
        let cuisineLabel = self.getLabelDescription(from: cell, with: "CuisineLabel")
        let recipeDescriptionLabel = self.getLabelDescription(from: cell, with: "RecipeDescriptionLabel")
        
        // Combine the labels into a single string, trimming whitespace and newlines
        return recipeNameLabel + cuisineLabel + recipeDescriptionLabel
    }
    
    /// goes down view hierarchy in order to fetch the element string
    private func getLabelDescription(from cell: XCUIElement, with identifier: String) -> String {
        let element = cell.descendants(matching: .staticText).matching(identifier: identifier).firstMatch
        return element.label
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
