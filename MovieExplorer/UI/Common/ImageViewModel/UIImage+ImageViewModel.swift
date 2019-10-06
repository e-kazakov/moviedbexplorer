//
//  UIImage+RemoteImage.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 16.06.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

extension MVE where Base: UIImageView {
  
  func setImage(_ image: ImageViewModel?) -> Disposable {
    
    guard let imageVM = image else {
      base.image = nil
      return NoOpDisposable()
    }
    
    base.image = nil
    
    var animated = false
    defer { animated = true }
    
    return imageVM.image { [weak base] image in
      guard let base = base else { return }
      if animated {
        base.mve.crossDissolveTransition {
          base.image = image
        }
      } else {
        base.image = image
      }
    }
  }
}
