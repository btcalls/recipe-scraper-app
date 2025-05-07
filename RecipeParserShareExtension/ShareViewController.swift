//
//  ShareViewController.swift
//  RecipeParserShareExtension
//
//  Created by Jason Jon Carreos on 6/5/2025.
//

import UIKit
import UniformTypeIdentifiers
import SwiftUI

// Based on https://agtlucas.com/blog/implementing-a-swift-ui-sharesheet-extension/
class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first
        else {
            self.close()
            
            return
        }
        
        let identifier = "public.url"
        
        if itemProvider.hasItemConformingToTypeIdentifier(identifier) {
            itemProvider.loadItem(forTypeIdentifier: identifier, options: nil) { [weak self] (url, error) in
                guard let self = self else {
                    return
                }
                
                guard error == nil, let sharedUrl = url as? URL else {
                    self.close()
                    
                    return
                }
                
                DispatchQueue.main.async {
                    let contentView = UIHostingController(rootView: ParseRecipeView(url: sharedUrl))
                    
                    self.addChild(contentView)
                    self.view.addSubview(contentView.view)
                    
                    contentView.view.translatesAutoresizingMaskIntoConstraints = false
                    contentView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                    contentView.view.bottomAnchor.constraint (equalTo: self.view.bottomAnchor).isActive = true
                    contentView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                    contentView.view.rightAnchor.constraint (equalTo: self.view.rightAnchor).isActive = true
                }
            }
        } else {
            close()
            
            return
        }
        
        NotificationCenter.default.addObserver(forName: .closeShareView,
                                               object: nil,
                                               queue: nil) { [weak self] _ in
            DispatchQueue.main.async {
                if let self {
                    self.close()
                }
            }
        }
    }
    
    func close() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
