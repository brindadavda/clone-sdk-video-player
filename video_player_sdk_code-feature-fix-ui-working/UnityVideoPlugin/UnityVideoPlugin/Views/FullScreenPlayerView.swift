//
//  FullScreenPlayerView.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 12/06/25.
//

import Foundation
import UIKit
import AVKit
import SwiftUI

struct FullScreenVideoPlayer: UIViewControllerRepresentable {
    let player: AVPlayer?
    

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        guard let player = player else { return controller }
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
      uiViewController.videoGravity = .resizeAspectFill
    }
}
