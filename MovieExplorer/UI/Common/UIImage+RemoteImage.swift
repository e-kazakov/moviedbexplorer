//
//  UIImage+RemoteImage.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 16.06.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

extension TMDB where Base: UIImageView {
  
  func setImage(remote: RemoteImageViewModelProtocol?) {
    
    guard let imageVM = remote else {
      base.image = nil
      return
    }
    
    base.image = imageVM.image ?? imageVM.placeholder
    base.alpha = imageVM.image == nil ? 0 : 1.0
    
    imageVM.onChanged = { [weak base, unowned imageVM] in
      guard let base = base else { return }
      
      if let image = imageVM.image {
        base.image = image
        if base.alpha < CGFloat(1.0) {
          UIView.animate(withDuration: 0.3) { base.alpha = 1.0 }
        }
      }
    }
  }
  
}
