//
//  VideoPlayerView.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 08/05/25.
//

import Foundation
import SwiftUI
import AVKit


public struct VideoPlayerView: View {
  @ObservedObject public var playerController: PlayerController
  
  @ObservedObject var orientationObserver = OrientationObserver()
  
  @StateObject private var controller =
  PlaylistController()
  
  private let bundle = Bundle(for: PlayerController.self) // No optional binding needed
  
  var isRunningOnMac: Bool {
#if targetEnvironment(macCatalyst)
    print("Program running on macOS")
    return true
#else
    return false
#endif
  }
  
  @State var showPlaylist: Bool = true
//  let playlist = Playlist.mockPlaylist
  @State var showNextPreview: Bool = false
  @State var selectedVideo: Video? = nil
  
  public init(playerController: PlayerController) {
    self.playerController = playerController
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      showCustomPlayer()
      
      if showPlaylist {
        PlaylistBottomView(
          controller: controller,
          onVideoSelected:  { video in
            self.playerController.currentIndex = controller.videos.firstIndex(where: { $0.id == video.id }) ?? 0
            self.playerController.loadVideo(urlString: video.url)
            self.selectedVideo = video
          },
          onPlaylistSelected: { playlist in
            controller.userSelectedPlaylist(playlist)
            let urls = controller.videos.map(\.url)
            self.playerController.setURLS(urls)
            if let index = controller.firstUnwatchedVideoID() {
              playerController.currentIndex = index
            }else {
              playerController.currentIndex = 0
            }
            self.playerController.play()
          }
        )
        .background(Color.black)
      }
    }
    .onAppear {
      playerController.attachPlaylist(controller)
    }
  }
}



struct ActivityIndicator: UIViewRepresentable {
  
  @Binding var isAnimating: Bool
  let style: UIActivityIndicatorView.Style
  
  func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
    return UIActivityIndicatorView(style: style)
  }
  
  func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
    isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
  }
}


//#Preview {
//    let playerController = PlayerController()
//    VideoPlayerView(playerController: playerController)
//}
//

struct PlayerView: View {
  
  //  private var urls: [String] = [
  //    "https://d1wfmi80ljcet8.cloudfront.net/13._How_to_Press_Flowers_and_more_science_DIY_videos_-_Darwin_and_Newts_comp/13._How_to_Press_Flowers_and_more_science_DIY_videos_-_Darwin_and_Newts_comp_1080.m3u8",
  //   "https://d1wfmi80ljcet8.cloudfront.net/14._Sound_Delay_Experiment_and_more_science_DIY_videos_-_Darwin_and_Newts_comp/14._Sound_Delay_Experiment_and_more_science_DIY_videos_-_Darwin_and_Newts_comp_1080.m3u8",
  //    "https://d1wfmi80ljcet8.cloudfront.net/15._Water_Siphon_Experiment_and_more_science_DIY_videos_-_Darwin_and_Newts_comp/15._Water_Siphon_Experiment_and_more_science_DIY_videos_-_Darwin_and_Newts_comp_1080.m3u8"
  //  ]
  
  //  var urls: [String] = Array(repeating: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", count: 3)
  
  let videoPlayerService = VideoPlayerService()
  
  var body: some View {
    Button("Play Video"){
      let urls = Playlist.mockPlaylist.videos.map(\.url)
      videoPlayerService.setURLS(urls: urls)
      videoPlayerService.play()
    }
    .onAppear {
      videoPlayerService.setShowFor10Button(true)
      videoPlayerService.setShowBack10Button(true)
    }
  }
}

#Preview {
  PlayerView()
}


extension VideoPlayerView {
  
  func showCustomPlayer() -> some View {
    ZStack {
      // Background video
      GeometryReader { geometry in
        
        VideoPlayer(player: playerController.player)
          .allowsHitTesting(isRunningOnMac)
          .contentShape(Rectangle())
          .onTapGesture {
            playerController.toggleControls()
            self.showPlaylist = true
          }
          .ignoresSafeArea()
          .blur(radius: showNextPreview ? 6 : 0)
          .overlay(
            Group {
              if showNextPreview {
                Color.black.opacity(0.35)
              }
            }
          )
        
        
        
        //                if showNextPreview, let video = selectedVideo {
        //                    ZStack {
        //                        showRemainingNextView(video)
        //                            .padding(24)
        ////                            .background(
        ////                                RoundedRectangle(cornerRadius: 20)
        ////                                    .fill(Color.white.opacity(0.9))
        ////                            )
        //                            .shadow(radius: 10)
        //                    }
        //                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        //                    .transition(.scale.combined(with: .opacity))
        //                    .animation(.easeInOut(duration: 0.25), value: showNextPreview)
        //                } else {
        VStack {
          
          //top nav bar
          HStack {
            // Back Button
            Button(action: {
              playerController.backToHome()
            }) {
              Image("backbutton",bundle: bundle)
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
            }
            .disabled(playerController.showLoading)
            
            Spacer()
            
            Image("skidosLogo", bundle: bundle)
              .resizable()
              .frame(width: 150, height: 50)
              .padding()
          }
          
          
          // Video Controls
          VStack {
            
            Spacer()
            
            let isLandscape = orientationObserver.orientation.isLandscape
            
            let buttonSize: CGFloat = (isLandscape || UIDevice.current.userInterfaceIdiom == .pad) ? 100 : 50
            
            HStack(spacing: 20) {
              
              Button(action: {
                playerController.prevVideo()
              }) {
                Image("prev", bundle: bundle)
                  .resizable()
                  .frame(width: buttonSize, height: buttonSize)
              }
              .isHidden(!playerController.showBackwordButton)
              .opacity(playerController.disableBackButton ? 0.5 : 1)
              .isDisabled(playerController.disableBackButton)
              
              Button(action: {
                playerController.seekBackward(seconds: 10)
              }) {
                Image("backword_10", bundle: bundle)
                  .resizable()
                  .frame(width: buttonSize, height: buttonSize)
              }
              
              .isHidden(!playerController.showBack10Button)
              
              Button(action: {
                if playerController.isPlaying {
                  playerController.pause()
                  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0){
                    self.showPlaylist = true
                  }
                }else{
                  playerController.play()
                  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0){
                    //                    self.showPlaylist = false
                  }
                }
                
              }) {
                Image(playerController.isPlaying ? "Pause" : "Play", bundle: bundle)
                  .resizable()
                  .foregroundColor(.blue)
                  .frame(width: buttonSize, height: buttonSize)
              }
              .isHidden(!playerController.showPlayPauseButton)
              
              Button(action: {
                playerController.seekForward(seconds: 10)
              }) {
                Image("forward_10", bundle: bundle)
                  .resizable()
                  .frame(width: buttonSize, height: buttonSize)
              }
              .isHidden(!playerController.showFor10Button)
              
              Button(action: {
                playerController.nextVideo()
              }) {
                Image("prev", bundle: bundle)
                  .resizable()
                  .rotationEffect(Angle(degrees: 180))
                  .frame(width: buttonSize, height: buttonSize)
              }
              .isHidden(!playerController.showForwardButton)
              .opacity(playerController.disbleForwardButton ? 0.5 : 1)
              .isDisabled(playerController.disbleForwardButton)
            }
            
            Spacer()
            
            // Progress bar
            HStack {
              let fontSize: CGFloat = orientationObserver.orientation.isLandscape ? 16 : 12
              
              // Time Labels
              Text("\(playerController.formatTime(seconds: playerController.currentTime))/\(playerController.formatTime(seconds: playerController.duration))")
                .foregroundColor(.black)
                .font(Font.system(size: fontSize, design: .monospaced))
                .bold()
                .background {
                  Image("gray_back", bundle: bundle)
                    .resizable()
                    .frame(width: 120, height: 50)
                }
                .padding()
                .isHidden(!playerController.showTimeDration)
              
              SwiftUISlider(value: $playerController.currentTime, isLandscape: isLandscape, maxValue: playerController.duration) { editing in
                if !editing {
                  playerController.seekTo(value: playerController.currentTime) // Only seek once user stops dragging
                  playerController.play()
                }else{
                  playerController.pause()
                }
              }
              .padding(.trailing, 16)
              .isHidden(!playerController.showSeekbar)
            }
            .padding(.bottom , UIDevice.current.userInterfaceIdiom == .pad ? 28 : 0)
            .padding(.bottom, isLandscape ? -20 : 24)
            
          }
        }
        .padding(.vertical, UIDevice.current.userInterfaceIdiom == .pad ? 120 : 24)
        .padding(.horizontal, 24)
        .isDisabled(playerController.showLoading)
        .isHidden(playerController.showLoading || isRunningOnMac)
        .opacity(playerController.showControls && !showNextPreview ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: playerController.showControls)
        //                }
        
        // Overlay content
        
      }
      .overlay {
        ActivityIndicator(isAnimating: $playerController.showLoading, style: .large)
      }
    }
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
      if playerController.shouldBePlayingAfterResume {
        playerController.play()
      }
    }
  }
}

struct NextPreview: View {
  let onVideoSelected: (Video) -> Void
  var video: Video
  
  init(video: Video,onVideoSelected: @escaping (Video) -> Void) {
    self.onVideoSelected = onVideoSelected
    self.video = video
  }
  
  var body: some View {
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
    .onTapGesture {
      onVideoSelected(video)
    }
  }
}


extension VideoPlayerView {
  
  func showRemainingNextView(_ video: Video) -> some View {
    HStack(spacing: 16) {
      
      Spacer()
      
      let isLandscape = orientationObserver.orientation.isLandscape
      
      let buttonSize: CGFloat = (isLandscape || UIDevice.current.userInterfaceIdiom == .pad) ? 100 : 50
      
      Button(action: {
        playerController.autoPlayCurrentVideo = true
      }) {
        Image("prev", bundle: bundle)
          .resizable()
          .frame(width: buttonSize, height: buttonSize)
      }
      .opacity(playerController.disableBackButton ? 0.5 : 1)
      .isDisabled(playerController.disableBackButton)
      
      
      NextPreview(video: video, onVideoSelected: { video in
        self.playerController.currentIndex = (Int(video.id) ?? 1) - 1
        self.playerController.loadVideo(urlString: video.url)
        print("video: \(video.id)")
        self.showNextPreview = false
      })
      .frame(width: 300, height: 180)
      
    }
  }
  
}

