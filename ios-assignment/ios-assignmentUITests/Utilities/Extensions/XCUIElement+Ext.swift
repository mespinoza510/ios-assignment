//
//
// Created by Marco Espinoza on 1/22/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import XCTest


enum AccessibilityIdentifers: String {
    case recipeNameLabel
    case cuisineLabel
    case recipeDescriptionLabel
    case loadMoreButton
    case sourceButton
    case youtubeButton
    case recipeLargeImageRendered
    
    var description: String {
        return self.rawValue
    }
}


extension XCUIElement {
    func element(for identifier: AccessibilityIdentifers) -> XCUIElement {
        switch identifier {
        case .recipeNameLabel, .cuisineLabel, .recipeDescriptionLabel:
            return self.staticTexts[identifier.description]
            case .loadMoreButton, .sourceButton, .youtubeButton:
            return self.buttons[identifier.description]
        case .recipeLargeImageRendered:
            return self.images[identifier.description]
        }
    }
}
