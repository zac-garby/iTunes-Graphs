//
//  ViewController.swift
//  iTunes Graphs
//
//  Created by Zac G on 04/07/2017.
//  Copyright © 2017 Zac G. All rights reserved.
//

import Cocoa
import iTunesLibrary

class ViewController: NSViewController {
  @IBOutlet var arrayController: NSArrayController!
  
  @IBOutlet weak var chart: Chart!
  @IBOutlet weak var colouredCircle: ColouredCircle!
  @IBOutlet weak var titleLabel: NSTextField!
  @IBOutlet weak var percentageLabel: NSTextField!
  @IBOutlet weak var table: NSTableView!
  
  var artists: [String:Int] = [:]
  var genres: [String:Int] = [:]
  var decades: [String:Int] = [:]
  
  var data: [Track] = []
  
  var artistData: [(String, Double)] = []
  var genreData: [(String, Double)] = []
  var decadeData: [(String, Double)] = []
  
  var selectedCategory: (String, NSColor)? = nil
  
  var tab = 0
  let maximumCategories = 10
  
  override func viewDidLoad() {
    chart.viewController = self
    
    table.dataSource = self
    table.dataSource?.tableView!(table, sortDescriptorsDidChange: [])
    
    let library: ITLibrary
    
    do {
      library = try ITLibrary(apiVersion: "1.0")
    } catch {
      print("Error occured!")
      return
    }
    
    let tracks = library.allMediaItems
    
    for track in tracks {
      if track.mediaKind == .kindSong {
        guard let artist = track.artist?.name else { return }
        let decade = Int(Double(track.year) / 10.0).description + "0s"
        
        data.append(Track(title: track.title, artist: artist, genre: track.genre, decade: decade))
        
        increment(key: artist, of: &artists)
        increment(key: track.genre, of: &genres)
        increment(key: decade.description, of: &decades)
      }
    }
    
    artistData = postprocess(dict: artists)
    genreData = postprocess(dict: genres)
    decadeData = postprocess(dict: decades)
    
    arrayController.content = data
        
    load(data: artistData)
  }
  
  @IBAction func changeTab(_ sender: NSSegmentedControl) {
    let data: [(String, Double)]
    
    tab = sender.selectedSegment
    
    switch sender.selectedSegment {
    case 0:
      data = Array(artistData)
    case 1:
      data = Array(genreData)
    case 2:
      data = Array(decadeData)
    default:
      data = []
    }
    
    load(data: data)
  }
  
  func updateInfoPanel() {
    guard let (title, colour) = selectedCategory else { return }
    
    colouredCircle.setColour(to: colour)
    
    titleLabel.stringValue = title == "\0\0" ? "Other" : title
    
    let percent = Int(round((chart.getPercentage(of: title) ?? 0) * 100))
    percentageLabel.stringValue = "\(percent)%"
    
    arrayController.content = filteredData()
  }
  
  func load(data: [(String, Double)]) {
    chart.load(data: data)
  }
}

