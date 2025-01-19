//
//
// Created by Marco Espinoza on 1/19/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import SafariServices
import SwiftUI


public struct SFSafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    public func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // no-op
    }
}
