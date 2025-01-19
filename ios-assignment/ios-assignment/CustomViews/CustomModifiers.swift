//
//
// Created by Marco Espinoza on 1/19/25
// Copyright © 2025 Marco Espinoza. All rights reserved.
//
    

import SwiftUI


private struct SFSafariViewModifier: ViewModifier {
    
    @Binding var urlToOpen: String?
    @State var isPresented: Bool = false
    
    func body(content: Content) -> some View {
        content
            .onChange(of: self.urlToOpen, { oldValue, newValue in
                self.isPresented = newValue != nil
            })
            .fullScreenCover(isPresented: self.$isPresented, onDismiss: {
                self.urlToOpen = nil
            }, content: {
                if let urlToString = self.urlToOpen,
                   let url = URL(string: urlToString) {
                    SFSafariView(url: url)
                }
            })
    }
}


extension View {
    public func openSafari(url: Binding<String?>) -> some View {
        modifier(SFSafariViewModifier(urlToOpen: url))
    }
}
