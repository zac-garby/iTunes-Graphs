//
//  Track.swift
//  iTunes Graphs
//
//  Created by Zac G on 05/07/2017.
//  Copyright © 2017 Zac G. All rights reserved.
//

import Cocoa

class Track: NSObject {
  var title: String
  var artist: String
  var genre: String
  var decade: String
  
  init(title: String, artist: String, genre: String, decade: String) {
    self.title = title
    self.artist = artist
    self.genre = genre
    self.decade = decade
  }
}
