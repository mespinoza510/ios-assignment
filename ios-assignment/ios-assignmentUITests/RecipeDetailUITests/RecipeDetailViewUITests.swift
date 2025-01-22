//
//
// Created by Marco Espinoza on 1/22/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import XCTest


class ReRecipeDetailViewUITests: BaseUITest {
    
    @MainActor
    func testAssertElementsInDetailView() throws {
        let cell = self.app.cells.element(boundBy: 0)
        cell.tap()
        
        XCTAssert(self.app.navigationBars["Apam Balik"].exists, "Navigation bar not found")
        XCTAssert(self.app.sourceButton.exists, "Source button not found")
        XCTAssert(self.app.youtubeButton.exists, "Youtube button not found")
    }
}
