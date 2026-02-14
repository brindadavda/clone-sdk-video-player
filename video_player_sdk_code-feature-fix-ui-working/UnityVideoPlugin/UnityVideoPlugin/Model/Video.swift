//
//  Video.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 08/02/26.
//

import Foundation

public struct Video: Codable {
    public var id: String
    public var url: String
    public var title: String
    public var description: String
    public var thumbnail: String
    public var isWatched: Bool = false
      
    init(id: String, url: String, title: String, description: String, thumbnail: String) {
        self.id = id
        self.url = url
        self.title = title
        self.description = description
        self.thumbnail = thumbnail
    }
}
