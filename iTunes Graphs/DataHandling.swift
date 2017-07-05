//
//  DataHandling.swift
//  iTunes Graphs
//
//  Created by Zac G on 04/07/2017.
//  Copyright © 2017 Zac G. All rights reserved.
//

import Cocoa

postfix operator %

postfix func % (percentage: Int) -> Double {
  return Double(percentage) / 100
}

postfix func % (percentage: Double) -> Double {
  return percentage / 100
}

extension ViewController {
  func increment(key: String, of dict: inout [String:Int]) {
    if dict.keys.contains(key) {
      dict[key] = dict[key]! + 1
    } else {
      dict[key] = 1
    }
  }
  
  func postprocess(dict: [String:Int]) -> [(String, Double)] {
    let total = dict.reduce(0.0) { (result, pair) in
      return result + Double(pair.value)
    }
    
    var data = convert(dict: dict)
    
    data = data.filter() { (_, value) in
      return value / total > 2%
    }
    
    data = data.sorted() { a, b in
      return a.1 > b.1
    }
    
    var trimmed: [(String, Double)] = data
    
    if data.count > maximumCategories {
      trimmed = Array(data.dropLast(data.count - maximumCategories))
    }
    
    let difference = dict.keys.count - trimmed.count
    trimmed.append(("\0\0", Double(difference)))
    
    return trimmed
  }
  
  func convert(dict: [String:Int]) -> [(String, Double)] {
    var data: [(String, Double)] = []
    
    for (key, value) in dict {
      data.append((key, Double(value)))
    }
    
    return data
  }
  
  func filteredData() -> [Track] {
    var result: [Track]
    let category = selectedCategory!.0
        
    switch tab {
    case 0:
      result = getFilteredData(
        category: category,
        of: artists,
        with: artistData,
        getKey: { object in return object.artist })
    case 1:
      result = getFilteredData(
        category: category,
        of: genres,
        with: genreData,
        getKey: { object in return object.genre })
    case 2:
      result = getFilteredData(
        category: category,
        of: decades,
        with: decadeData,
        getKey: { object in return object.decade })
    default:
      result = []
    }
    
    
    return result.sorted() { a, b in
      return a.title < b.title
    }
  }
  
  func getFilteredData(category: String,
                       of dict: [String:Int],
                       with dataArray: [(String, Double)],
                       otherName: String = "\0\0",
                       getKey: (Track) -> String) -> [Track] {

    if category == otherName {
      let other = dict.filter() { item in
        let name = item.0
        
        let isOther = !dataArray.contains() { item in
          return item.0 == name
        }
        
        return isOther
      }
      
      return data.filter() { (object: Track) in
        return other.contains() { item in
          return getKey(object) == item.0
        }
      }
    }
    
    return data.filter() { (object: Track) in
      return getKey(object) == category
    }
  }
}

extension ViewController: NSTableViewDataSource {
  func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
    let content = arrayController.content as! [Track]
    
    let nsArray = NSArray(array: content)
    let array = nsArray.sortedArray(using: tableView.sortDescriptors)
    arrayController.content = array
  }
}
