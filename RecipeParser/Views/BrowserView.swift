//
//  BrowserView.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 6/5/2025.
//

import SwiftUI
import SafariServices

struct BrowserView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        let controller = SFSafariViewController(url: URL(string: "https://www.google.com")!)
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        return
    }
}
