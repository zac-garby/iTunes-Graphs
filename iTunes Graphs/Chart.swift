//
//  PieChart.swift
//  iTunes Graphs
//
//  Created by Zac G on 04/07/2017.
//  Copyright © 2017 Zac G. All rights reserved.
//

import Cocoa

@IBDesignable
class Chart: NSView {
  var viewController: ViewController? = nil
  var data: [(String, Double)] = [("", 40), ("", 20), ("", 60), ("", 45), ("", 60), ("", 40)]
  var paths: [String:(NSBezierPath, NSColor)] = [:]
  var colours: [NSColor] = [.red, .white]
  
  override func draw(_ dirtyRect: NSRect) {
    drawPie()
  }
  
  func drawPie() {
    let center = NSPoint(x: bounds.width / 2, y: bounds.height / 2)
    let radius = min(bounds.width, bounds.height) * 0.4
    
    let anglePerUnit = 360 / getTotal()
    
    var startAngle = 30.0
    var colourIndex = 0
    
    paths = [:]
    
    for (key, value) in data {
      let angle = value * anglePerUnit
      
      let path = NSBezierPath()
      
      path.move(to: center)
      
      path.appendArc(withCenter: center, radius: radius,
                     startAngle: CGFloat(startAngle),
                     endAngle: CGFloat(startAngle + angle))
      
      path.move(to: center)
      
      let colour = colours[colourIndex]

      colour.setFill()
      path.fill()
      
      startAngle += angle
      colourIndex = (colourIndex + 1) % colours.count
      
      paths[key] = (path, colour)
    }
  }
  
  func getTotal() -> Double {
    return data.reduce(0.0, { result, pair in return result + pair.1 })
  }
  
  func getPercentage(of key: String) -> Double? {
    if let (_, amount) = data.first(where: { category in return category.0 == key }) {
      return amount / getTotal()
    }
    
    return nil
  }
  
  func generateColours() -> [NSColor] {
    let count = Double(data.count)
    var hue = 0.0
    var colours: [NSColor] = []
    
    for (key, _) in data {
      if key == "\0\0" {
        colours.append(NSColor(calibratedHue:0.00, saturation:0.00, brightness:0.8, alpha:1.00))
      } else {
        colours.append(NSColor(calibratedHue: CGFloat(hue), saturation: 0.65, brightness: 1.00, alpha: 1.00))
        hue += 1 / count
      }
      
    }
    
    return colours
  }
  
  func load(data: [(String, Double)]) {
    self.data = data
    colours = generateColours()
    
    if viewController != nil && data.count > 0 {
      viewController?.selectedCategory = (data.first!.0, colours.first!)
      viewController?.updateInfoPanel()
    }
    
    needsDisplay = true
  }
  
  override func mouseDown(with event: NSEvent) {
    changeSelection(with: event)
  }
  
  override func mouseDragged(with event: NSEvent) {
    changeSelection(with: event)
  }
  
  private func changeSelection(with event: NSEvent) {
    let point = event.locationInWindow
    
    for (key, (path, colour)) in paths {
      if path.contains(point) {
        viewController?.selectedCategory = (key, colour)
        viewController?.updateInfoPanel()
      }
    }
  }
}
