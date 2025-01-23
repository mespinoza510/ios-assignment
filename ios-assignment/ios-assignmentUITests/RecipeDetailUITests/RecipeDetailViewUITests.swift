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
        XCTAssert(self.app.recipeLargeImageRendered.exists, "Image not found")
        XCTAssert(self.app.sourceButton.exists, "Source button not found")
        XCTAssert(self.app.youtubeButton.exists, "Youtube button not found")
    }
    
    @MainActor
    func testRecipeDetailViewSourceButtonTappedAssertWebpage() {
        self.tapCell(at: 0)
        self.app.sourceButton.tap()
        
        sleep(5) // in-app webpage to load
        
        XCTAssert(self.app.webViews.element.exists, "Web view not found")
    }
    
    @MainActor
    func testRecipeDetailViewYoutubeButtonTappedAssertWebpage() {
        self.tapCell(at: 0)
        self.app.youtubeButton.tap()
        
        sleep(5)
        
        XCTAssert(self.app.webViews.element.exists, "Web view not found")
    }
}
