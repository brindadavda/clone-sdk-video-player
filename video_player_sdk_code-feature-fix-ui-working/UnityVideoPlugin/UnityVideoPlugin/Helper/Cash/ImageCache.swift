//
//  ImageCache.swift
//  UnityVideoPlugin
//
//  Created by Enpointe on 12/02/26.
//

import UIKit

final class ImageCache {
    
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
