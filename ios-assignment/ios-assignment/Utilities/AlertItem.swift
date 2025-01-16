//
//
// Created by Marco Espinoza on 1/15/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
    
    var alert: Alert {
        Alert(title: self.title, message: self.message, dismissButton: self.dismissButton)
    }
}


enum AppError: Error, Identifiable {
    case invalidURL
    case invalidResponse
    case decodingError
    
    var id: UUID {
        UUID()
    }
    
    var title: Text {
        switch self {
        case .invalidURL:
            return Text("Invalid URL")
        case .invalidResponse:
            return Text("Invalid Response")
        case .decodingError:
            return Text("Decoding Error")
        }
    }
    
    var message: Text {
        switch self {
        case .invalidURL:
            return Text("Please enter a valid URL")
        case .invalidResponse:
            return Text("There is an error in the response. Please check your URL")
        case .decodingError:
            return Text("There is a mismatch found from model. Please check your JSON")
        }
    }
    
    var dismissButton: Alert.Button {
        .default(Text("OK"))
    }
    
    var alertItem: AlertItem {
        return AlertItem(
            title: self.title,
            message: self.message,
            dismissButton: self.dismissButton)
    }
}
