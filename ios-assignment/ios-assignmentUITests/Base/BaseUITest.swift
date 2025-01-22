//
//
// Created by Marco Espinoza on 1/22/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import XCTest


class BaseUITest: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        super.setUp()
        self.app = XCUIApplication()
        self.app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        self.app.terminate()
        self.app = nil
        super.tearDown()
    }

    // MARK: - Common Methods
    func waitForElement(_ element: XCUIElement, timeout: TimeInterval = 1) -> Bool {
        return element.waitForExistence(timeout: timeout)
    }

    func swipeUp(in element: XCUIElement) {
        element.swipeUp()
    }

    func swipeToBottom(of list: XCUIElement) {
        let lastVisibleCell = self.getLastVisibleCell(in: list)
        var lastVisibleLabel = self.getCombinedLabel(from: lastVisibleCell)
        
        while lastVisibleCell.isHittable {
            list.swipeUp()
            sleep(1)
            let updatedLastVisibleCell = self.getLastVisibleCell(in: list)
            let updatedLastVisibleLabel = self.getCombinedLabel(from: updatedLastVisibleCell)
            if lastVisibleLabel == updatedLastVisibleLabel {
                break
            }
            lastVisibleLabel = updatedLastVisibleLabel
        }
    }

    func waitForCell(at index: Int, timeout: TimeInterval = 1) -> XCUIElement {
        let cell = app.cells.element(boundBy: index)
        XCTAssertTrue(self.waitForElement(cell, timeout: timeout), "Cell \(index) did not appear in time.")
        return cell
    }

    func swipeUpToLoadMoreButton(in list: XCUIElement) {
        while !app.loadMoreButton.exists {
            swipeUp(in: list)
        }
    }

    func tapLoadMoreButton() {
        let button = self.app.loadMoreButton
        XCTAssertTrue(button.exists, "Load more button does not exist.")
        button.tap()
    }

    // MARK: - Helper Methods
    private func getLastVisibleCell(in list: XCUIElement) -> XCUIElement {
        let cells = list.cells
        let lastVisibleCellIndex = cells.count - 1
        return cells.element(boundBy: lastVisibleCellIndex)
    }

    private func getCombinedLabel(from cell: XCUIElement) -> String {
        let recipeNameLabel = getLabelDescription(from: cell, with: "RecipeNameLabel")
        let cuisineLabel = getLabelDescription(from: cell, with: "CuisineLabel")
        let recipeDescriptionLabel = getLabelDescription(from: cell, with: "RecipeDescriptionLabel")
        
        return recipeNameLabel + cuisineLabel + recipeDescriptionLabel
    }

    private func getLabelDescription(from cell: XCUIElement, with identifier: String) -> String {
        let element = cell.descendants(matching: .staticText).matching(identifier: identifier).firstMatch
        return element.label
    }
}

