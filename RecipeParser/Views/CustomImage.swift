//
//  CustomImage.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 22/5/2025.
//

import SwiftUI

private struct ImageBody: View {
    var kind: CustomImage.Kind
    
    var body: some View {
        switch kind {
        case .url(let url, let toCache):
            AsyncLoadImage(url: url, toCache: toCache)
            
        case .resource(let resource):
            Image(resource)
                .resizable()
            
        case .uiImage(let uiImage):
            Image(uiImage: uiImage)
                .resizable()
        }
    }
}

struct CustomImage: View {
    var kind: Kind
    
    var body: some View {
        ImageBody(kind: kind)
            .scaledToFill()
            .clipped()
    }
}

extension CustomImage {
    enum Kind {
        case resource(String)
        case url(URL?, toCache: Bool = true)
        case uiImage(UIImage)
    }
}

private struct AsyncLoadImage: View {
    var url: URL?
    var toCache: Bool
    
    @State private var urlImage: Image?
    @State private var error: Error?
    @State private var isLoading = false
    
    var body: some View {
        if let urlImage {
            // Image successfully fetched
            urlImage
                .resizable()
        } else if let _ = error {
            // Failed image loading
            Symbol.xmarkCircle.image
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
}

private extension AsyncLoadImage {
    /// Starts loading an image from given URL.
    /// - Parameters:
    ///   - url: The image URL to load.
    ///   - toCache: Flag whether to cache image or not.
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
    
    /// Perform data request for an image URL.
    /// - Parameters:
    ///   - request: The request to start.
    ///   - toCache: Flag whether to cache data or not.
    /// - Returns: The image data.
    func fetchImage(from request: URLRequest,
                    toCache: Bool) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if toCache {
            let cachedData = CachedURLResponse(response: response, data: data)
            
            URLCache.shared.storeCachedResponse(cachedData, for: request)
        }
        
        return data
    }
}

#Preview {
    VStack {
        CustomImage(kind: .url(MockService.shared.imageURL))
            .scale(.heightWidth(), 100)
            .clipTo(Circle(), lineWidth: 1, color: .primary)
        
        CustomImage(kind: .url(MockService.shared.getRecipe().imageURL))
            .scale(.height(), 250)
            .fitToAspectRatio(.photo4x3)
            .clipTo(RoundedRectangle(cornerRadius: .large))
    }
    .frame(maxWidth: .infinity)
    .padding(20)
}
