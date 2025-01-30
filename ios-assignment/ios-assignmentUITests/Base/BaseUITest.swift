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
    
    func waitForElementToAppear(element: XCUIElement, timeout: TimeInterval = 5) {
        let existPredicate = NSPredicate(format: "exists == true")
        
        let _ = self.expectation(for: existPredicate, evaluatedWith: element)
        
        self.waitForExpectations(timeout: timeout)
        
        XCTAssertTrue(element.exists, "Element not found after waiting for \(timeout) seconds.")
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
    
    // MARK: - Assert methods
    func assertElementExists(_ identifier: AccessibilityIdentifers, in parent: XCUIElement? = nil) {
        let element = parent?.element(for: identifier) ?? self.app.element(for: identifier)
        XCTAssertTrue(element.exists, "Could not find \(identifier.rawValue) in the specified parent element.")
    }
    
    func assertWebElementExists(for element: XCUIElement, _ identifier: String, expectedValue: String) {
        let valueOfElementWithIdentifier = self.getValueDescription(from: element, with: identifier)
        
        // Assert that the element exists and has the expected value
        XCTAssert(element.exists, "Could not find \(identifier) in the specified element.")
        XCTAssert(valueOfElementWithIdentifier.contains(expectedValue), "\(identifier) does not contain the expected value.")
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
    
    /// goes down view hierarchy to get descendants that have meaniningful elements
    private func getValueDescription(from element: XCUIElement, with identifier: String) -> String {
        // Get the first button with the given identifier and retrieve its value
        guard let value = element.descendants(matching: .any).matching(identifier: identifier).firstMatch.value as? String else {
            XCTFail("The element with the identifier '\(identifier)' does not have a value.")
            return ""
        }
        return value // Return an empty string if no value is found
    }
}

