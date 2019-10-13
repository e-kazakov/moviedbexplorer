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
  var image: UIImage? { get }
  
  var onChanged: (() -> Void)? { get set }
  
  func load()
  func cancel()
}

class RemoteImageViewModel: ImageViewModel {
  
  private(set) var image: UIImage? {
    didSet {
      notifyQueue.async {
        self.onChanged?()
      }
    }
  }
  
  var onChanged: (() -> Void)?
  
  private let placeholder: UIImage?
  private let url: URL
  private let fetcher: ImageFetcher

  private var fetchDisposable: Disposable?
  
  private let notifyQueue = DispatchQueue.main
    
  init(url: URL, placeholder: UIImage? = nil, fetcher: ImageFetcher) {
    self.url = url
    self.placeholder = placeholder
    self.fetcher = fetcher
  }
  
  func load() {
    guard fetchDisposable == nil else { return }
    
    fetchDisposable = fetcher.fetch(from: url) { [weak self] result in
      self?.handleFetchResult(result)
    }
  }
  
  func cancel() {
    fetchDisposable?.dispose()
    fetchDisposable = nil
  }
  
  private func handleFetchResult(_ result: Result<UIImage, APIError>) {
    fetchDisposable = nil
    
    switch result {
    case .success(let image):
      self.image = image
    case .failure:
      image = placeholder
    }
  }
}

class StaticImageViewModel: ImageViewModel {
  
  let image: UIImage?
  var onChanged: (() -> Void)?
  
  init(image: UIImage) {
    self.image = image
  }
  
  func load() {
    // no-op
  }

  func cancel() {
    // no-op
  }
}
