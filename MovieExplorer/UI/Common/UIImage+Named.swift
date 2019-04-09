//
//  UIImage+Named.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 4/10/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

extension UIImage {
  
  static var tmdb: TMDB<UIImage> {
    return TMDB(holder: self)
  }
  
}

struct TMDB<T> {
  var holder: T.Type
}

extension TMDB where T: UIImage {
  
  var starO: UIImage {
    return UIImage(named: "star-o-ic")!
  }
  
  var starFilled: UIImage {
    return UIImage(named: "star-filled-ic")!
  }
  
}
