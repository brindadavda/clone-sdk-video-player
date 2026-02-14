////
////  VideoPlayerView+E1.swift
////  UnityVideoPlugin
////
////  Created by Enpointe on 12/02/26.
////
//
//import SwiftUI
//
//extension VideoPlayerView {
//    
//    var controlsView: some View {
//        VStack {
//            
//            topBar
//            
//            Spacer()
//            
//            playbackControls
//            
//            progressBar
//        }
//        .padding()
//        .background(Color.black.opacity(0.3))
//    }
//    
//    var topBar: some View {
//        HStack {
//            Button(action: {
//                playerController.backToHome()
//            }) {
//                Image("backbutton", bundle: bundle)
//                    .resizable()
//                    .frame(width: 40, height: 40)
//            }
//            
//            Spacer()
//            
//            Image("skidosLogo", bundle: bundle)
//                .resizable()
//                .frame(width: 120, height: 40)
//        }
//    }
//    
//    var playbackControls: some View {
//        HStack(spacing: 24) {
//            
//            Button {
//                playerController.prevVideo()
//            } label: {
//                Image("prev", bundle: bundle)
//                    .resizable()
//                    .frame(width: 50, height: 50)
//            }
//            .disabled(playerController.disableBackButton)
//            
//            Button {
//                playerController.seekBackward(seconds: 10)
//            } label: {
//                Image("backword_10", bundle: bundle)
//                    .resizable()
//                    .frame(width: 50, height: 50)
//            }
//            
//            Button {
//                playerController.isPlaying ?
//                playerController.pause() :
//                playerController.play()
//            } label: {
//                Image(playerController.isPlaying ? "Pause" : "Play", bundle: bundle)
//                    .resizable()
//                    .frame(width: 60, height: 60)
//            }
//            
//            Button {
//                playerController.seekForward(seconds: 10)
//            } label: {
//                Image("forward_10", bundle: bundle)
//                    .resizable()
//                    .frame(width: 50, height: 50)
//            }
//            
//            Button {
//                playerController.nextVideo()
//            } label: {
//                Image("prev", bundle: bundle)
//                    .resizable()
//                    .rotationEffect(.degrees(180))
//                    .frame(width: 50, height: 50)
//            }
//            .disabled(playerController.disbleForwardButton)
//        }
//    }
//    
//    var progressBar: some View {
//        VStack {
//            
//            Text(
//                "\(playerController.formatTime(seconds: playerController.currentTime)) / " +
//                "\(playerController.formatTime(seconds: playerController.duration))"
//            )
//            .font(.system(size: 12, design: .monospaced))
//            
//            Slider(
//                value: $playerController.currentTime,
//                in: 0...max(playerController.duration, 1)
//            ) { editing in
//                if editing {
//                    playerController.pause()
//                } else {
//                    playerController.seekTo(value: playerController.currentTime)
//                    playerController.play()
//                }
//            }
//        }
//    }
//}
