//
//  PlaylistController.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 12/02/26.
//

import SwiftUI
import Combine

public final class PlaylistController: ObservableObject {

    // MARK: - Published State
    
    @Published public var currentVideoID: String?
    @Published public var countdownVideoID: String?
    @Published public var remainingTime: Int = 0
    @Published private(set) var completedVideosByPlaylist: [String: Set<String>] = [:]
    
    @Published public var currentPlaylist: Playlist
    @Published public var nextPlaylist: Playlist?
    
    // MARK: - Private
    
    private var timer: Timer?
    private var countdownTriggeredForVideoID: String?
    
    public var videos: [Video]
    public var playlists: [Playlist] = Playlist.allPlaylists
    
    // MARK: - Init
    
    public init(initialPlaylist: Playlist = Playlist.mockPlaylist) {
        
        self.currentPlaylist = initialPlaylist
        self.videos = initialPlaylist.videos
        
        // Determine next playlist safely
      if let index = playlists.firstIndex(where: { $0.id == initialPlaylist.id }),
         index + 1 < playlists.count {
          self.nextPlaylist = playlists[index + 1]
      } else {
        self.nextPlaylist = nil
      }
    }
  
  deinit {
      print("🧼 PlaylistController instance cleaned up – resources released successfully!")
  }
}

// MARK: - Computed Helpers

private extension PlaylistController {
    
    /// Returns completed videos for current playlist
    var completedVideoIDs: Set<String> {
        completedVideosByPlaylist[currentPlaylist.id] ?? []
    }
}


// MARK: - Public Helpers (For UI)

extension PlaylistController {
    
    func state(for video: Video) -> VideoState {
        
        if currentVideoID == video.id {
            return .watching
        }
        
        if countdownVideoID == video.id {
            return .nextVideo
        }
        
        if completedVideoIDs.contains(video.id) {
            return .completed
        }
        
        return .none
    }
    
    func remainingTime(for video: Video) -> Int {
        if countdownVideoID == video.id {
            return remainingTime
        }
        return 0
    }
    
    func cancelCountdown() {
        
        // Stop timer safely
        timer?.invalidate()
        timer = nil
        
        // Clear countdown state
        countdownVideoID = nil
        remainingTime = 0
    }


}

extension PlaylistController {
    
    func videoStarted(id: String) {
        cancelCountdown()
        currentVideoID = id
        countdownTriggeredForVideoID = nil
    }
    
    func videoCompleted(id: String) {
      // Update per-playlist progress
             var set = completedVideosByPlaylist[currentPlaylist.id] ?? []
             set.insert(id)
             completedVideosByPlaylist[currentPlaylist.id] = set
             
             // Optional local flag update
             if let index = videos.firstIndex(where: { $0.id == id }) {
                 videos[index].isWatched = true
             }
    }
  
  func allVideoWatched() -> Bool {
    return completedVideoIDs.count == videos.count
  }
  
  func firstUnwatchedVideoID() -> Int? {
    return videos.map( \.id ).firstIndex(where: { !completedVideoIDs.contains($0) })
  }
}


extension PlaylistController {
    
  func triggerCountdownIfNeeded(currentID: String, remainingSeconds: Int) {
         
         guard remainingSeconds <= 20 else { return }
         
         // Prevent multiple triggers
         guard let index = videos.firstIndex(where: { $0.id == currentID }),
               index + 1 < videos.count else { return  }
         
         let nextVideo = videos[index + 1]
         countdownVideoID = nextVideo.id
         remainingTime = remainingSeconds
         countdownTriggeredForVideoID = currentID
     }
}



extension PlaylistController {
    
    /// Returns the correct video ID to resume from
    func nextVideoToPlayOnReturn() -> String? {
        
      let completed = completedVideoIDs
            
            // 1️⃣ Find earliest unwatched
            for video in videos {
                if !completed.contains(video.id) {
                    return video.id
                }
            }
            
            // 2️⃣ If all watched → restart
            return videos.first?.id
    }
}


extension PlaylistController {
  
  func loadAllplaylist() -> [Playlist] {
    return Playlist.allPlaylists
  }

}


// MARK: - User Actions

extension PlaylistController {
    
    func userSelectedVideo(id: String) {
        videoStarted(id: id)
    }
    
    func userSelectedPlaylist(_ playlist: Playlist?) {
        
        cancelCountdown()
        
        // Switch playlist
        guard let playlist = playlist else { return }
        currentPlaylist = playlist
        videos = playlist.videos
        
        // Resume from correct video
        currentVideoID = nextVideoToPlayOnReturn()
        setNextPlaylist()
    }
  
    func setNextPlaylist() {
      if let index = playlists.firstIndex(where: { $0.id == currentPlaylist.id }),
         index + 1 < playlists.count {
          self.nextPlaylist = playlists[index + 1]
      } else {
        self.nextPlaylist = nil
      }
  }
}
