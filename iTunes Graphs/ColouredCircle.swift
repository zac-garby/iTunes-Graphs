//
//  ColouredCircle.swift
//  iTunes Graphs
//
//  Created by Zac G on 04/07/2017.
//  Copyright © 2017 Zac G. All rights reserved.
//

import Cocoa

@IBDesignable
class ColouredCircle: NSView {
  @IBInspectable var colour: NSColor = .black
  
  override func draw(_ dirtyRect: NSRect) {
    let path = NSBezierPath(ovalIn: dirtyRect)
    colour.setFill()
    path.fill()
  }
  
  func setColour(to colour: NSColor) {
    self.colour = colour
    needsDisplay = true
  }
}
