//
//  PlaylistCardView.swift
//  UnityVideoPlugin
//

import SwiftUI

import SwiftUI

struct PlaylistCardView: View {
    
    let title: String
    let imageURL: String
    let size: CGSize
    
    private var cornerRadius: CGFloat {
        size.width * 0.12
    }
    
    private var stackOffset: CGFloat {
        size.height * 0.06
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            ZStack {
                
                // MARK: - Stacked Background
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                    .frame(width: size.width * 0.88,
                           height: size.height * 0.95)
                    .offset(y: -stackOffset * 2)
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                    .frame(width: size.width * 0.94,
                           height: size.height * 0.98)
                    .offset(y: -stackOffset * 0.5)
                    .shadow(color: .black.opacity(0.25), radius: 8)
                
                
                // MARK: - Main Card
                
                ZStack(alignment: .bottomLeading) {
                    
                  CachedAsyncImage(urlString: imageURL)
                    .frame(width: size.width, height: size.height-stackOffset * 2)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    
                    
                    // Title Overlay
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .padding(.bottom, 12)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                      Color.white.opacity(0.33)
                    )
                }
                .frame(width: size.width, height: size.height-stackOffset * 2)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.white, lineWidth: 3)
                )
            }
            .frame(width: size.width, height: size.height)
            
            Spacer(minLength: 0)
        }
        .padding(.vertical)
    }
}


#Preview {
  PlaylistCardView(
    title: Playlist.mockPlaylist.name ?? "",
    imageURL: Playlist.mockPlaylist.videos[0].thumbnail,
    size: CGSize(width: 150, height: 150)
//    height: 150,
//    gap: 5
  )
//  .padding()
  .background(Color.black)
}
