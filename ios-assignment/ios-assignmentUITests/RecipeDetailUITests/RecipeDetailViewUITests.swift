//
//
// Created by Marco Espinoza on 1/22/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import XCTest


class RecipeDetailViewUITests: BaseUITest {
    
    //MARK: - Tests that have all elements in detail view
    @MainActor
    func testAssertElementsInDetailView() {
        self.tapCell(at: 0)
        
        XCTAssert(self.app.navigationBars["Apam Balik"].exists, "Navigation bar not found")
        self.assertElementExists(.recipeLargeImageRendered)
        self.assertElementExists(.sourceButton)
        self.assertElementExists(.youtubeButton)
    }
    
    @MainActor
    func testRecipeDetailViewSourceButtonTappedAssertWebpage() {
        self.tapCell(at: 0)
        self.app.element(for: .sourceButton).tap()
        
        self.waitForElementToAppear(element: self.app.webViews.element)
    }
    
    @MainActor
    func testRecipeDetailViewSourceButtonTappedAssertWebpageButtons() {
        self.tapCell(at: 0)
        self.app.element(for: .sourceButton).tap()
        
        self.waitForElementToAppear(element: self.app.webViews.element)
        
        let addressButtonLabel = self.app.buttons["Address"]
        self.waitForElementToAppear(element: addressButtonLabel)
        
        self.assertWebElementExists(for: addressButtonLabel, "URL", expectedValue: "nyonyacooking.com")
    }
    
    @MainActor
    func testRecipeDetailViewYoutubeButtonTappedAssertWebpageText() {
        self.tapCell(at: 0)
        self.app.element(for: .youtubeButton).tap()
        
        self.waitForElementToAppear(element: self.app.webViews.element)
        
        let tapToUnmuteButtonLabel = self.app.buttons["TAP TO UNMUTE"]
        self.waitForElementToAppear(element: tapToUnmuteButtonLabel)
        
        XCTAssertEqual(tapToUnmuteButtonLabel.label, "TAP TO UNMUTE", "YouTube page is not loaded or 'TAP TO UNMUTE' button is not found")
    }
}
