//
//
// Created by Marco Espinoza on 1/22/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import XCTest


extension XCUIElement {
    var recipeNameLabel: XCUIElement {
        return self.staticTexts["recipeNameLabel"]
    }
    
    var cuisineLabel: XCUIElement {
        return self.staticTexts["cuisineLabel"]
    }
    
    var recipeDescriptionLabel: XCUIElement {
        return self.staticTexts["recipeDescriptionLabel"]
    }
    
    var loadMoreButton: XCUIElement {
        return self.buttons["loadMoreButton"]
    }
    
    var sourceButton: XCUIElement {
        return self.buttons["sourceButton"]
    }
    
    var youtubeButton: XCUIElement {
        return self.buttons["youtubeButton"]
    }
    
    var recipeLargeImageRendered: XCUIElement {
        return self.images["recipeLargeImageRendered"]
    }
    
    var recipeLargeImagePlaceholder: XCUIElement {
        return self.images["recipeLargeImagePlaceholder"]
    }
}
