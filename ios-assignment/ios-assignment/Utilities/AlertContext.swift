//
//
// Created by Marco Espinoza on 1/15/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import SwiftUI


@MainActor
final class AlertContext: ObservableObject {
    @Published var alertType: AppError?
    
    public func showAlert(_ error: AppError) {
        self.alertType = error
    }
}
