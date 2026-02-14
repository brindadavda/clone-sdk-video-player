//
//  CachedAsyncImage.swift
//  UnityVideoPlugin
//
//  Created by Enpointe on 12/02/26.
//

import SwiftUI

struct CachedAsyncImage: View {
    
    let urlString: String
    
    @State private var image: UIImage?
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        
        guard let url = URL(string: urlString) else { return }
        
        // 1️⃣ Check cache first
        if let cached = ImageCache.shared.image(forKey: urlString) {
            self.image = cached
            return
        }
        
        // 2️⃣ Avoid duplicate loading
        guard !isLoading else { return }
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let downloadedImage = UIImage(data: data)
            else { return }
            
            // Save to cache
            ImageCache.shared.set(downloadedImage, forKey: urlString)
            
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }.resume()
    }
}
