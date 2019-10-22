//
//  RemoteImageViewModel.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/18/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation
import class UIKit.UIImage
import class UIKit.UIView


protocol ImageViewModel: class {
//  var image: UIImage? { get }
//
//  var onChanged: (() -> Void)? { get set }
//
  func image(_ callback: @escaping (UIImage?) -> Void) -> Disposable

  func load()
//  func cancel()
}

class RemoteImageViewModel: ImageViewModel {
  
//  var image: UIImage? {
//    get {
//      imageStorage
//    }
//    set {
//      imageStorage = newValue
//      notifyQueue.async {
//        self.onChanged?()
//      }
//    }
//  }
  
//  private weak var imageStorage: UIImage?
  
//  var onChanged: (() -> Void)?
  
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
