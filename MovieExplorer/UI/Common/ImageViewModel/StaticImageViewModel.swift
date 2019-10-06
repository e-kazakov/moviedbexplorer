//
//  StaticImageViewModel.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 1/8/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import UIKit

class StaticImageViewModel: ImageViewModel {
  
  let image: UIImage?

  init(image: UIImage) {
    self.image = image
  }
  
  func image(_ callback: @escaping (UIImage?) -> Void) -> Disposable {
    callback(image)
    return NoOpDisposable()
  }

  func load() {
    // no-op
  }
}
