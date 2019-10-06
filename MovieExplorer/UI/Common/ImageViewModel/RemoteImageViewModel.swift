//
//  RemoteImageViewModel.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 1/8/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import UIKit

class RemoteImageViewModel: ImageViewModel {
  
  private let notifyQueue = DispatchQueue.main
  private let placeholder: UIImage?
  private let url: URL
  private let fetcher: ImageFetcher

  private var fetchDisposable: Disposable?
      
  init(url: URL, placeholder: UIImage? = nil, fetcher: ImageFetcher) {
    self.url = url
    self.placeholder = placeholder
    self.fetcher = fetcher
  }
  
  func image(_ callback: @escaping (UIImage?) -> Void) -> Disposable {
    return fetcher.fetch(from: url) { [weak self] result in
      func handle() {
        switch result {
        case .success(let image):
          callback(image)
        case .failure:
          callback(self?.placeholder)
        }
      }
      
      if Thread.isMainThread {
        handle()
      } else {
        DispatchQueue.main.async {
          handle()
        }
      }
    }
  }

  func load() {
    _ = fetcher.fetch(from: url) { _ in }
  }
}
