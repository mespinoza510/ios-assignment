//
//
// Created by Marco Espinoza on 1/22/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import XCTest


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
    
    var sourceButton: XCUIElement {
        return self.buttons["sourceButton"]
    }
    
    var youtubeButton: XCUIElement {
        return self.buttons["youtubeButton"]
    }
}
