//
//  CustomImage.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 22/5/2025.
//

import SwiftUI

// TODO: Handle async loading of image

struct CustomImage: View {
    enum Content {
        case resource(String)
        case url(URL?, toCache: Bool = true)
        case uiImage(UIImage)
    }
    
    var content: Content
    
    @State private var isLoading = false
    @State private var urlImage: Image? = nil
    @State private var error: Error?
    
    @ViewBuilder private func asyncImage(_ url: URL?, toCache: Bool) -> some View {
        if let urlImage {
            // Image successfully fetched
            urlImage
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else if let _ = error {
            // Failed image loading
            Symbol.forkKnife.image
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .imageScale(.large)
                .background(.quaternary)
        } else {
            // Loading/Placeholder
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tint(.primary)
                .background(.quaternary)
                .onAppear {
                    Task {
                        await loadImage(from: url, toCache: toCache)
                    }
                }
        }
    }
    
    var body: some View {
        switch content {
        case .resource(let resource):
            Image(resource)
                .resizable()
                .aspectRatio(contentMode: .fill)
        
        case .url(let url, let toCache):
            asyncImage(url, toCache: toCache)
            
        case .uiImage(let uiImage):
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

private extension CustomImage {
    func loadImage(from url: URL?, toCache: Bool) async {
        guard let url, !isLoading else {
            return
        }
        
        isLoading = true
        
        // Check if the image is already cached
        let request = URLRequest(url: url)
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let cachedImage = UIImage(data: cachedResponse.data) {
            await MainActor.run {
                urlImage = Image(uiImage: cachedImage)
                isLoading = false
            }
            
            return
        }
        
        // Fetch image data from URLRequest
        do {
            let data = try await fetchImage(from: request, toCache: toCache)
            
            if let uiImage = UIImage(data: data) {
                await MainActor.run {
                    urlImage = Image(uiImage: uiImage)
                    isLoading = false
                }
            }
        } catch(let e) {
            await MainActor.run {
                error = e
                isLoading = false
            }
        }
    }
    
    func fetchImage(from request: URLRequest, toCache: Bool) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if toCache {
            let cachedData = CachedURLResponse(response: response, data: data)
            
            URLCache.shared.storeCachedResponse(cachedData, for: request)
        }
        
        return data
    }
}

#Preview {
    CustomImage(content: .url(URL(string: "https://www.recipetineats.com/tachyon/2024/07/Baked-Beef-Quasadillas-51259.jpg")))
        .frame(width: 200, height: 200)
        .clipTo(Circle(),
                lineWidth: 1,
                color: .primary)
}
