//
//  PlaylistVideoView.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 11/02/26.
//

//
//  PlaylistVideoView.swift
//

import SwiftUI

struct PlaylistVideoView: View {
    
    let video: Video
    @ObservedObject var controller: PlaylistController
    var size = CGSize(width: 200, height: 200)
    let onSelected: (Video) -> Void
    
    var body: some View {
        
        let state = controller.state(for: video)
        let remaining = controller.remainingTime(for: video)
        
        VStack(alignment: .leading, spacing: 12) {
            
            ZStack {
                thumbnailView(size: size, state: state)
                overlayView(size: size,
                            state: state,
                            remainingTime: remaining)
            }
            .frame(width: size.width, height: size.height)
            
            Text(video.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white.opacity(0.9))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(height: 44, alignment: .top)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onTapGesture {
            controller.userSelectedVideo(id: video.id)
            onSelected(video)
        }
    }
}



// MARK: - Preview

#Preview {
  PlaylistVideoView(video: Playlist.mockPlaylist.videos[2], controller: PlaylistController()) { video in
        print("Selected video: \(video)")
    }
    .padding()
    .background(Color.gray)
}
