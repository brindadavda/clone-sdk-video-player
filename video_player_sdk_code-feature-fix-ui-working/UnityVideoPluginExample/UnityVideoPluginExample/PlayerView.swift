//
//  PlayerView.swift
//  UnityVideoPluginExample
//
//  Created by Brinda Davda on 08/05/25.
//

import SwiftUI
import UnityVideoPlugin

struct PlayerView: View {
  
//  private var urls: [String] = [
//    "https://d1wfmi80ljcet8.cloudfront.net/13._How_to_Press_Flowers_and_more_science_DIY_videos_-_Darwin_and_Newts_comp/13._How_to_Press_Flowers_and_more_science_DIY_videos_-_Darwin_and_Newts_comp_1080.m3u8",
//   "https://d1wfmi80ljcet8.cloudfront.net/14._Sound_Delay_Experiment_and_more_science_DIY_videos_-_Darwin_and_Newts_comp/14._Sound_Delay_Experiment_and_more_science_DIY_videos_-_Darwin_and_Newts_comp_1080.m3u8",
//    "https://d1wfmi80ljcet8.cloudfront.net/15._Water_Siphon_Experiment_and_more_science_DIY_videos_-_Darwin_and_Newts_comp/15._Water_Siphon_Experiment_and_more_science_DIY_videos_-_Darwin_and_Newts_comp_1080.m3u8"
//  ]
  
  var urls: [String] = Array(repeating: "https://d1wfmi80ljcet8.cloudfront.net/14._Sound_Delay_Experiment_and_more_science_DIY_videos_-_Darwin_and_Newts_comp/14._Sound_Delay_Experiment_and_more_science_DIY_videos_-_Darwin_and_Newts_comp_1080.m3u8", count: 3)
    
    let videoPlayerService = VideoPlayerService()
  

    var body: some View {
        Button("Play Video"){
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
