//
//  AspectRatio.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/22/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

struct AspectRatio {
  
  let width: Double
  let height: Double
  
  var ratio: Double { width / height }
  
  func size(forHeight height: CGFloat) -> CGSize {
    CGSize(width: CGFloat(ratio) * height, height: height)
  }
  
  func size(forWidth width: CGFloat) -> CGSize {
    CGSize(width: width, height: width / CGFloat(ratio))
  }
}
