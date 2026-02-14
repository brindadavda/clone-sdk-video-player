//
//  VideoPlayerService.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 02/05/25.
//
import Foundation

public class VideoPlayerService {
    
    public var playerController: PlayerController?
    
    public init() {
        self.playerController = PlayerController()
    }
    
    public var currentIndex: Int {
        get {
            playerController?.currentIndex ?? 0
        }
        set {
            playerController?.currentIndex = newValue
        }
    }
    public func loadVideo(urlString: String) {
        playerController?.loadVideo(urlString: urlString)
    }
    
    public func play() {
        playerController?.play()
    }
    
    public func pause() {
        playerController?.pause()
    }
    
    public func stop() {
        playerController?.stop()
    }
    
    public func seekForward(seconds: Double) {
        playerController?.seekForward(seconds: seconds)
    }
    
    public func seekBackward(seconds: Double) {
        playerController?.seekBackward(seconds: seconds)
    }
    
    public func cleanup() {
        playerController?.cleanup()
        playerController = nil
    }
    
    public func seekTo(value: Double) {
        playerController?.seekTo(value: value)
    }
    
    public func setURLS(urls: [String]) {
        if playerController == nil {
            playerController = PlayerController()
        }
        playerController?.setURLS(urls)
    }
    
    // MARK: - Visibility control (with main-thread dispatch)
    
    public func setShowForwardButton(_ visible: Bool) {
        DispatchQueue.main.async {
            self.playerController?.showForwardButton = visible
        }
    }
    
    public func setShowBackwordButton(_ visible: Bool) {
        DispatchQueue.main.async {
            self.playerController?.showBackwordButton = visible
        }
    }
    
    public func setShowBack10Button(_ visible: Bool) {
        DispatchQueue.main.async {
            self.playerController?.showBack10Button = visible
        }
    }
    
    public func setShowFor10Button(_ visible: Bool) {
        DispatchQueue.main.async {
            self.playerController?.showFor10Button = visible
        }
    }
    
    public func setShowPlayPauseButton(_ visible: Bool) {
        DispatchQueue.main.async {
            self.playerController?.showPlayPauseButton = visible
        }
    }
    
    public func setShowBackButton(_ visible: Bool) {
        DispatchQueue.main.async {
            self.playerController?.showBackButton = visible
        }
    }
    
    public func setShowLogo(_ visible: Bool) {
        DispatchQueue.main.async {
            self.playerController?.showLogo = visible
        }
    }
    
    public func setShowSeekbar(_ visible: Bool) {
        DispatchQueue.main.async {
            self.playerController?.showSeekbar = visible
        }
    }
    
    public func setShowTimeDuration(_ visible: Bool) {
        DispatchQueue.main.async {
            self.playerController?.showTimeDration = visible
        }
    }
}
