//
//  UIColor+Ext.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 15.06.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit.UIColor

extension UIColor {

  convenience init(rgb: Int) {
    let r = (rgb >> 16) & 0xFF
    let g = (rgb >> 8) & 0xFF
    let b = rgb & 0xFF

    self.init(red: CGFloat(r)/255.0,
              green: CGFloat(g)/255.0,
              blue: CGFloat(b)/255.0,
              alpha: 1.0)
  }
  
  convenience init(rgba: Int) {
    let r = (rgba >> 24) & 0xFF
    let g = (rgba >> 16) & 0xFF
    let b = (rgba >> 8) & 0xFF
    let a = rgba & 0xFF

    self.init(red: CGFloat(r)/255.0,
              green: CGFloat(g)/255.0,
              blue: CGFloat(b)/255.0,
              alpha: CGFloat(a)/255.0)
  }
  
  func darker(by brightnessOffset: CGFloat) -> UIColor {
    var hue = 0 as CGFloat
    var saturation = 0 as CGFloat
    var brightness = 0 as CGFloat
    var alpha = 0 as CGFloat
    self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    
    let darkerBrightness = clamp(brightness - brightnessOffset, 0.0, 1.0)
    
    return UIColor(hue: hue, saturation: saturation, brightness: darkerBrightness, alpha: alpha)
  }
  
  func lighter(by brightnessOffset: CGFloat) -> UIColor {
    var hue = 0 as CGFloat
    var saturation = 0 as CGFloat
    var brightness = 0 as CGFloat
    var alpha = 0 as CGFloat
    self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    
    let lighterBrightness = clamp(brightness + brightnessOffset, 0.0, 1.0)
    
    return UIColor(hue: hue, saturation: saturation, brightness: lighterBrightness, alpha: alpha)
  }

}
