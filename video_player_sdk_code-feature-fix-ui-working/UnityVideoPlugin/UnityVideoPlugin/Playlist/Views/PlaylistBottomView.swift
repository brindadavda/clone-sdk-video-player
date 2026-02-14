//
//  PlaylistBottomView.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 11/02/26.
//

import SwiftUI

struct PlaylistBottomView: View {
    
    @ObservedObject var controller: PlaylistController
    var onVideoSelected: (Video) -> Void = { _ in }
    var onPlaylistSelected: (Playlist) -> Void = { _ in }
    
    var isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        
        let width: CGFloat = isPad ? 250 : 130
        let height: CGFloat = isPad ? 320 : 280
        let spacing: CGFloat = isPad ? 24 : 12
        let thumbnailSize = CGSize(width: width, height: width)
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            LazyHStack(alignment: .top, spacing: spacing) {
                
              ForEach(controller.currentPlaylist.videos, id: \.id) { video in
                    PlaylistVideoView(
                        video: video,
                        controller: controller,
                        size: thumbnailSize
                    ) { selectedVideo in
                        onVideoSelected(video)
                    }
                    .frame(width: width, height: height)
                }
              
              if let nextPlaylist = controller.nextPlaylist {
                PlaylistCardView(
                  title: controller.nextPlaylist?.name ?? "",
                    imageURL: controller.nextPlaylist?.videos[0].thumbnail ?? "",
                    size: CGSize(width: width, height: width - 10)
                )
                .onTapGesture {
                  onPlaylistSelected(nextPlaylist)
                }
              }
            }
            .padding()
        }
//        .background(.gray)
    }
}


#Preview {
  PlaylistBottomView(
  controller: PlaylistController(),
  onVideoSelected: { video in
    print("video: \(video.id)")
  },
  onPlaylistSelected: { playlist in
    print("playlist: \(playlist.id)")
  })
  
}


enum SelectionType {
    case playlist
    case video
}
