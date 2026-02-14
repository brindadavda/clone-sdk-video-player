//
//  UnityVideoPlugin.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 02/05/25.
//

import Foundation
import SwiftUI
import AVKit
import UIKit
import Combine

public class PlayerController: NSObject, ObservableObject {
  @Published public var player: AVPlayer? = AVPlayer()
  @Published public var isPlaying: Bool = false
  @Published public var currentTime: Double = 0
  @Published public var duration: Double = 1
  @Published public var buttonSize: CGFloat = 50
  @Published public var showForwardButton: Bool = true
  @Published public var showBackwordButton: Bool = true
  @Published public var showBack10Button: Bool = true
  @Published public var showFor10Button: Bool = true
  @Published public var showPlayPauseButton: Bool = true
  @Published public var showBackButton: Bool = true
  @Published public var showLogo: Bool = true
  @Published public var showSeekbar: Bool = true
  @Published public var showTimeDration: Bool = true
  @Published public var showLoading: Bool = false
  @Published public var disableBackButton: Bool = false
  @Published public var disbleForwardButton: Bool = false
  @Published public var showControls: Bool = true
  @Published private var hideControlsWorkItem: DispatchWorkItem?
  var shouldBePlayingAfterResume: Bool = false
  @Published var autoPlayCurrentVideo: Bool = false
  
  public weak var playlistController: PlaylistController?

  private var urls: [String] = Array(repeating: "https://d142uv38695ylm.cloudfront.net/videos/promo/allesneu.land-promo-trailer-360p.m3u8", count: 5)
  
  @Published public var currentIndex: Int = 0
  private var timeObserverToken: Any?
  public var hostingController: UIHostingController<VideoPlayerView>?
  
  public override init() {}
  
  public func setURLS(_ urls: [String]) {
    self.urls = urls
  }
  
  public func attachPlaylist(_ playlist: PlaylistController) {
      self.playlistController = playlist
    self.playlistController?.currentVideoID = playlist.videos[currentIndex].id
  }
  
  private func currentVideoID() -> String {
      return playlistController?.videos[currentIndex].id ?? ""
  }

  
  // MARK: - Video Loading

  public func loadVideo(urlString: String) {
      debugPrint("current index: \(currentIndex)")
      showLoadingUI(true)
      guard let url = URL(string: urlString) else { return }
      cleanup()

      let playerItem = AVPlayerItem(url: url)
      if player == nil{
          player = AVPlayer()
      }
      player?.replaceCurrentItem(with: playerItem)
      player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)

      observeDuration()
      addPeriodicTimeObserver()
    
    if currentIndex == 0 {
      disableBackButton = true
      disbleForwardButton = false
    } else if currentIndex == urls.count - 1 {
      disbleForwardButton = true
      disableBackButton = false
    } else {
      disableBackButton = false
      disbleForwardButton = false
    }
    

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(playerDidFinishPlaying),
      name: .AVPlayerItemDidPlayToEndTime,
      object: playerItem
    )

      if hostingController == nil {
          presentVideoPlayer()
      }else{
        play()
      }
    
    autoHideControls()
    
    playlistController?.videoStarted(id: currentVideoID())

  }
  
  override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
      if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
          let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
          let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
          if newStatus != oldStatus {
              DispatchQueue.main.async {[weak self] in
                  if newStatus == .playing || newStatus == .paused {
                      self?.showLoadingUI(false)
                  } else {
                      self?.showLoadingUI(true)
                  }
              }
          }
      }
  }
  
  @objc private func playerDidFinishPlaying(_ notification: Notification) {
      
      guard let playlist = playlistController,
            let currentID = playlist.currentVideoID,
            let index = playlist.videos.firstIndex(where: { $0.id == currentID }) else {
          return
      }
      
      playlist.videoCompleted(id: currentID)
      
      if index + 1 < playlist.videos.count {
          let nextVideo = playlist.videos[index + 1]
          loadVideo(urlString: urls[index + 1])
          playlist.videoStarted(id: nextVideo.id)
      } else {
          // Fully completed show
          if playlist.allVideoWatched() {
            if playlist.nextPlaylist == nil {
              self.playlistController = nil
              backToHome()
            } else {
              guard let nextPlaylist = playlist.nextPlaylist else { return }
              playlist.userSelectedPlaylist(nextPlaylist)
              let urls = playlist.videos.map(\.url)
              setURLS(urls)
              if let index = playlist.firstUnwatchedVideoID() {
                currentIndex = index
              }else {
                currentIndex = index
              }
            }
          } else {
            if let index = playlist.firstUnwatchedVideoID() {
              currentIndex = index
            }else {
              currentIndex = index
            }
          }
        print("currentIndex")
          loadVideo(urlString: urls[currentIndex])
          let restartID = playlist.videos[currentIndex].id
          playlist.videoStarted(id: restartID)
      }
  }

  
  
  func showLoadingUI(_ isLoading: Bool) {
    showLoading = isLoading
  }

  
  // MARK: - Video Controls
  
  public func play() {
    if (currentIndex <= urls.count - 1 && currentIndex >= 0) && !urls.isEmpty {
      if hostingController == nil {
        loadVideo(urlString: urls[currentIndex])
      }
    }
    isPlaying = true
    autoHideControls()
    shouldBePlayingAfterResume = true
    autoPlayCurrentVideo = false
    player?.play()
  }
  
  public func pause() {
    isPlaying = false
    autoHideControls()
    shouldBePlayingAfterResume = false
    player?.pause()
  }
  
  public func stop() {
    pause()
    autoHideControls()
    seekTo(value: 0)
  }
  
  public func nextVideo() {
    guard currentIndex < urls.count - 1 else { return disbleForwardButton = true}
    currentIndex += 1
    autoHideControls()
    loadVideo(urlString: urls[currentIndex])
  }
  
  public func prevVideo() {
    guard currentIndex > 0 else { return disableBackButton = true }
    currentIndex -= 1
    autoHideControls()
    loadVideo(urlString: urls[currentIndex])
  }
  
  public func seekForward(seconds: Double) {
    let newTime = (player?.currentTime().seconds ?? 0) + seconds
    autoHideControls()
    seekTo(value: newTime)
  }
  
  public func seekBackward(seconds: Double) {
    let newTime = (player?.currentTime().seconds ?? 0) - seconds
    autoHideControls()
    seekTo(value: max(0, newTime))
  }
  
  public func seekTo(value: Double) {
    let time = CMTime(seconds: value, preferredTimescale: 600)
   player?.seek(to: time)
  }
  
  public func getURLs() -> [String] {
    return urls
  }
  
  // MARK: - UI Presentation
  
  private func presentVideoPlayer() {
    let playerView = VideoPlayerView(playerController: self)
    // Use self.hostingController instead of a local variable
    self.hostingController = UIHostingController(rootView: playerView)
    self.hostingController?.modalPresentationStyle = .overFullScreen
    
    if let topController = UIApplication.shared.topMostViewController(),
       let hostingController = self.hostingController {
      topController.present(hostingController, animated: true, completion: nil)
    }
  }
  
  
  public func backToHome() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
      guard let self = self else { return }
      self.hostingController?.dismiss(animated: true, completion: {
          if let currentVideoPlayerService = currentVideoPlayerService {
              currentVideoPlayerService.cleanup()
          }else{
              VideoPlayerService().cleanup()
          }
        self.hostingController = nil
        self.player = nil
        self.currentIndex = 0
      })
    }
  }

  
  
  // MARK: - Observers
  
  func addPeriodicTimeObserver() {
      let interval = CMTime(seconds: 0.5,
                            preferredTimescale: CMTimeScale(NSEC_PER_SEC))
      
      timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval,
                                                          queue: .main) { [weak self] time in
          guard let self = self else { return }
          
          self.currentTime = time.seconds
          
          let remaining = Int(self.duration - self.currentTime)
          
          if let currentID = self.playlistController?.currentVideoID {
              self.playlistController?.triggerCountdownIfNeeded(
                  currentID: currentID,
                  remainingSeconds: remaining
              )
          }
      }
  }
  
  func observeDuration() {
    guard let currentItem = player?.currentItem else { return }
    let durationSeconds = currentItem.asset.duration.seconds
    if durationSeconds.isFinite {
      duration = durationSeconds
    }
  }

  
  // MARK: - Formatting
  
  public func formatTime(seconds: Double) -> String {
    let totalSeconds = Int(seconds)
    return String(format: "%02d:%02d", totalSeconds / 60, totalSeconds % 60)
  }
  
  // MARK: - Cleanup
  
  public func cleanup() {
    print("🧹 Cleaning up player")
    if let token = timeObserverToken {
      player?.removeTimeObserver(token)
      timeObserverToken = nil
      player?.removeObserver(self, forKeyPath: "timeControlStatus")
      NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    player?.seek(to: .zero)
    player?.pause()
    player?.replaceCurrentItem(with: nil)
    currentTime = 0
    duration = 1
    isPlaying = false
  }
  
  
  public func toggleControls() {
    showControls.toggle()
    if showControls {
      autoHideControls()
    } else {
      hideControlsWorkItem?.cancel()
    }
  }
  
  public func autoHideControls() {
    hideControlsWorkItem?.cancel()
    let workItem = DispatchWorkItem {
      withAnimation {
        self.showControls = false
      }
    }
    hideControlsWorkItem = workItem
    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: workItem) // hides after 5 seconds
  }
  
  deinit {
      print("🧼 PlayerController instance cleaned up – resources released successfully!")
  }

}


