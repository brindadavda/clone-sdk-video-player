//
//  PlaylistResponse.swift
//  UnityVideoPlugin
//
//  Created by Enpointe on 12/02/26.
//

import Foundation

// MARK: - Root
public typealias PlaylistResponse = [PlaylistCategory]

// MARK: - Category
public struct PlaylistCategory: Codable {
    public let id: String
    public let episodes: [Episode]
}

// MARK: - Episode
public struct Episode: Codable {
    public let index: Int
    public let url: String
    public let thumbnail: String
    public let title: String
    public let isActive: Int
    public let length: Int
}

extension Episode {
    
    func toVideo(categoryId: String) -> Video {
        Video(
            id: "\(index)",
            url: url.trimmingCharacters(in: .whitespacesAndNewlines),
            title: title,
            description: categoryId,
            thumbnail: thumbnail
        )
    }
}
