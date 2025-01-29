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

    func waitForCell(at index: Int, timeout: TimeInterval = 5) -> XCUIElement {
        let cell = self.app.cells.element(boundBy: index)
        XCTAssertTrue(self.waitForElement(cell, timeout: timeout), "Cell \(index) did not appear in time.")
        return cell
    }
    
    func tapCell(at index: Int) {
        let cell = self.app.cells.element(boundBy: index)
        cell.tap()
    }

    func swipeUpToLoadMoreButton(in list: XCUIElement) {
        while !self.app.element(for: .loadMoreButton).exists {
            swipeUp(in: list)
        }
    }

    func tapLoadMoreButton() {
        let button = self.app.element(for: .loadMoreButton)
        XCTAssertTrue(button.exists, "Load more button does not exist.")
        button.tap()
    }
    
    func assertElementExists(_ identifier: AccessibilityIdentifers, in parent: XCUIElement? = nil) {
        let element = parent?.element(for: identifier) ?? self.app.element(for: identifier)
        XCTAssertTrue(element.exists, "Could not find \(identifier.rawValue) in the specified parent element.")
    }
    
    // MARK: - Helper Methods
    private func getLastVisibleCell(in list: XCUIElement) -> XCUIElement {
        let cells = list.cells
        let lastVisibleCellIndex = cells.count - 1
        return cells.element(boundBy: lastVisibleCellIndex)
    }
    
    /// concatenates the string of the cell label
    private func getCombinedLabel(from cell: XCUIElement) -> String {
        let recipeNameLabel = getLabelDescription(from: cell, with: "recipeNameLabel")
        let cuisineLabel = getLabelDescription(from: cell, with: "cuisineLabel")
        let recipeDescriptionLabel = getLabelDescription(from: cell, with: "recipeDescriptionLabel")
        
        return recipeNameLabel + cuisineLabel + recipeDescriptionLabel
    }
    
    /// goes down view hierarchy in order to fetch the element string
    private func getLabelDescription(from cell: XCUIElement, with identifier: String) -> String {
        let element = cell.descendants(matching: .staticText).matching(identifier: identifier).firstMatch
        return element.label
    }
}

