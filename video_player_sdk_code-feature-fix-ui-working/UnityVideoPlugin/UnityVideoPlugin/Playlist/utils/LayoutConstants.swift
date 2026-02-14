//
//  LayoutConstants.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 11/02/26.
//

import SwiftUI

struct LayoutConstants {
    
    static func videoCardSize(for geometry: GeometryProxy) -> CGSize {
        let isLandscape = geometry.size.width > geometry.size.height
        
        if isLandscape {
            return CGSize(
                width: geometry.size.width * 0.6,
                height: geometry.size.height * 0.6
            )
        } else {
            return CGSize(
                width: geometry.size.width * 0.9,
                height: geometry.size.height * 0.3
            )
        }
    }
}
