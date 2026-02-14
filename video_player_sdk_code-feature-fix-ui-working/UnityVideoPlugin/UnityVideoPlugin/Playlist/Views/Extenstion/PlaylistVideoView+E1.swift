//
//  PlaylistVideoView+E1.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 11/02/26.
//

import SwiftUI

extension PlaylistVideoView {
    
    func thumbnailView(size: CGSize,
                       state: VideoState) -> some View {
        
      CachedAsyncImage(urlString: video.thumbnail)
        .frame(width: size.width, height: size.height)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.black.opacity(state == .none ? 0 : 0.5))
        )
    }
    
    @ViewBuilder
    func overlayView(size: CGSize,
                     state: VideoState,
                     remainingTime: Int) -> some View {
        
        switch state {
            
        case .completed:
            VStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
                Text("Watched")
                    .font(.system(size: 20, weight: .bold))
            }
            .foregroundStyle(.white)
            
        case .nextVideo:
            Text("Playing in \(remainingTime)s")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
            
        case .watching:
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white, lineWidth: 4)
                .frame(width: size.width, height: size.height)
            
        case .none:
            EmptyView()
        }
    }
}
