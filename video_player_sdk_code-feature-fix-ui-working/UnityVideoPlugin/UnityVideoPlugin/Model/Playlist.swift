//
//  Playlist.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 08/02/26.
//

import Foundation

public struct Playlist: Codable, Identifiable {
  public var id: String
  public var name: String?
  public var description: String?
  public var videos: [Video]
  
  public static var mockPlaylist: Playlist = {
    SampleVideos.dinoWorldPlaylist
  }()
  
  public static var allPlaylists: [Playlist] = [SampleVideos.dinoWorldPlaylist, SampleVideos.Playlist2]
  
}

//
//  SampleVideos.swift
//  UnityVideoPlugin
//

import Foundation

public enum SampleVideos {
    
    public static let dinoWorldPlaylist = Playlist(
        id: "https://d1wfmi80ljcet8.cloudfront.net/Dino_World_Who_Am_I/Dino_World_Who_Am_I_1080.m3u8",
        name: "Dino World",
        description: "Dinosaur Adventures",
        videos: [
            
            Video(id: "1",
                  url: "https://d1wfmi80ljcet8.cloudfront.net/Dino_World_Who_Am_I/Dino_World_Who_Am_I_1080.m3u8",
                  title: "Who Am I",
                  description: "Dino World",
                  thumbnail: "https://d1lfhez3du8qvs.cloudfront.net/PinkFong-Videos/Thumbnails/Dino+World/101+EN.png"),
            
            Video(id: "2",
                  url: "https://d1wfmi80ljcet8.cloudfront.net/Dino_World_Im_a_Chef_Today/Dino_World_Im_a_Chef_Today_1080.m3u8",
                  title: "I'm a Chef Today",
                  description: "Dino World",
                  thumbnail: "https://d1lfhez3du8qvs.cloudfront.net/PinkFong-Videos/Thumbnails/Dino+World/102+EN.png"),
            
            Video(id: "3",
                  url: "https://d1wfmi80ljcet8.cloudfront.net/Dino_World_If_Dinosaurs_were_still_alive/Dino_World_If_Dinosaurs_were_still_alive_1080.m3u8",
                  title: "If Dinosaurs were still alive",
                  description: "Dino World",
                  thumbnail: "https://d1lfhez3du8qvs.cloudfront.net/PinkFong-Videos/Thumbnails/Dino+World/103+EN.png"),
            
            Video(id: "4",
                  url: "https://d1wfmi80ljcet8.cloudfront.net/Dino_World_Dinosaurs_A_to_Z/Dino_World_Dinosaurs_A_to_Z_1080.m3u8",
                  title: "Dinosaurs A to Z",
                  description: "Dino World",
                  thumbnail: "https://d1lfhez3du8qvs.cloudfront.net/PinkFong-Videos/Thumbnails/Dino+World/104+EN.png"),
            
            Video(id: "5",
                  url: "https://d1wfmi80ljcet8.cloudfront.net/Dino_World_Dinosaur_Parade/Dino_World_Dinosaur_Parade_1080.m3u8",
                  title: "Dinosaur Parade",
                  description: "Dino World",
                  thumbnail: "https://d1lfhez3du8qvs.cloudfront.net/PinkFong-Videos/Thumbnails/Dino+World/105+EN.png"),
            
            Video(id: "6",
                  url: "https://d1wfmi80ljcet8.cloudfront.net/Dino_World_I_am_the_Best/Dino_World_I_am_the_Best_1080.m3u8",
                  title: "I am the Best",
                  description: "Dino World",
                  thumbnail: "https://d1lfhez3du8qvs.cloudfront.net/PinkFong-Videos/Thumbnails/Dino+World/106+EN.png"),
            
            Video(id: "7",
                  url: "https://d1wfmi80ljcet8.cloudfront.net/Dino_World_Where_Did_The_Dinosaurs_Go/Dino_World_Where_Did_The_Dinosaurs_Go_1080.m3u8",
                  title: "Where Did The Dinosaurs Go",
                  description: "Dino World",
                  thumbnail: "https://d1lfhez3du8qvs.cloudfront.net/PinkFong-Videos/Thumbnails/Dino+World/107+EN.png"),
            
            Video(id: "8",
                  url: "https://d1wfmi80ljcet8.cloudfront.net/Dino_World_Move_Like_The_Dinosaurs/Dino_World_Move_Like_The_Dinosaurs_1080.m3u8",
                  title: "Move Like The Dinosaurs",
                  description: "Dino World",
                  thumbnail: "https://d1lfhez3du8qvs.cloudfront.net/PinkFong-Videos/Thumbnails/Dino+World/108+EN.png"),
            
            Video(id: "9",
                  url: "https://d1wfmi80ljcet8.cloudfront.net/Dino_World_Boom_Boom_Dino_World/Dino_World_Boom_Boom_Dino_World_1080.m3u8",
                  title: "Boom Boom Dino World",
                  description: "Dino World",
                  thumbnail: "https://d1lfhez3du8qvs.cloudfront.net/PinkFong-Videos/Thumbnails/Dino+World/109+EN.png"),
            
            Video(id: "10",
                  url: "https://d1wfmi80ljcet8.cloudfront.net/Dino_World_Tyrannosaurus_Rex/Dino_World_Tyrannosaurus_Rex_1080.m3u8",
                  title: "Tyrannosaurus Rex",
                  description: "Dino World",
                  thumbnail: "https://d1lfhez3du8qvs.cloudfront.net/PinkFong-Videos/Thumbnails/Dino+World/110+EN.png")
        ]
    )
  
  
  public static let Playlist2 = Playlist(
      id: "https://d1wfmi80ljcet8.cloudfront.net/Dino_World_Move_Like_The_Dinosaurs/Dino_World_Move_Like_The_Dinosaurs_1080.m3u8",
      name: "Dino",
      description: "Dinosaur Adventures",
      videos: [
          
          
          Video(id: "8",
                url: "https://d1wfmi80ljcet8.cloudfront.net/Dino_World_Move_Like_The_Dinosaurs/Dino_World_Move_Like_The_Dinosaurs_1080.m3u8",
                title: "Move Like The Dinosaurs",
                description: "Dino World",
                thumbnail: "https://d1lfhez3du8qvs.cloudfront.net/PinkFong-Videos/Thumbnails/Dino+World/108+EN.png"),
          
          Video(id: "9",
                url: "https://d1wfmi80ljcet8.cloudfront.net/Dino_World_Boom_Boom_Dino_World/Dino_World_Boom_Boom_Dino_World_1080.m3u8",
                title: "Boom Boom Dino World",
                description: "Dino World",
                thumbnail: "https://d1lfhez3du8qvs.cloudfront.net/PinkFong-Videos/Thumbnails/Dino+World/109+EN.png"),
          
          Video(id: "10",
                url: "https://d1wfmi80ljcet8.cloudfront.net/Dino_World_Tyrannosaurus_Rex/Dino_World_Tyrannosaurus_Rex_1080.m3u8",
                title: "Tyrannosaurus Rex",
                description: "Dino World",
                thumbnail: "https://d1lfhez3du8qvs.cloudfront.net/PinkFong-Videos/Thumbnails/Dino+World/110+EN.png")
      ]
  )
}
