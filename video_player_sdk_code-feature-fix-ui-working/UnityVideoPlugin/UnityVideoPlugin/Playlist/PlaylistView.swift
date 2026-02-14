//
//  PlaylistView.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 08/02/26.
//

import Foundation
import SwiftUI

public struct PlaylistView: View {
    
    var playlist : Playlist
    let onVideoSelected: (Video) -> Void
//    @State var showVideo: Bool = false
    
    public init(playlist: Playlist = Playlist.mockPlaylist, onVideoSelected: @escaping (Video) -> Void) {
//        self._service = service
        self.onVideoSelected = onVideoSelected
        self.playlist = playlist
    }
    
    public var body: some View {
        ZStack {
            
//            if showVideo {
//                VideoPlayerView(playerController: service.playerController ?? PlayerController())
//            } else {
            
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(playlist.videos, id: \.id) { video in
                            AsyncImage(url: URL(string: video.thumbnail)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 250, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                case .empty:
                                    ProgressView()
                                        .frame(width: 200, height: 200)
                                    
                                default:
                                    Color.gray
                                        .frame(width: 200, height: 200)
                                        .cornerRadius(10)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                onVideoSelected(video)
                            }
                        }
                    }
                    .padding()
//                    .frame(maxHeight: 100)
//                }
            }
        }
    }
}

#Preview {
//    @State var previewService = VideoPlayerService()
    return PlaylistView() { video in
        print("url: \(video.url)")
    }
}
