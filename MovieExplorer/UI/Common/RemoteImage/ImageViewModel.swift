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


protocol ImageViewModelProtocol: class {
  var image: UIImage? { get }
  
  var onChanged: (() -> Void)? { get set }
  
  func load()
  func cancel()
}

class RemoteImageViewModel: ImageViewModelProtocol {
  
  private(set) var image: UIImage? {
    didSet {
      onChanged?()
    }
  }
  
  var onChanged: (() -> Void)?
  
  private let placeholder: UIImage?
  private let url: URL
  private let fetcher: ImageFetcher

  private var imageTask: URLSessionDataTaskProtocol?
    
  init(url: URL, placeholder: UIImage? = nil, fetcher: ImageFetcher) {
    self.url = url
    self.placeholder = placeholder
    self.fetcher = fetcher
  }
  
  func load() {
    guard imageTask == nil else { return }
    imageTask = fetcher.fetch(from: url) { result in
      self.imageTask = nil
      
      switch result {
      case .success(let data):
        let image = UIImage(data: data)?.decoded()
        DispatchQueue.main.async {
          self.image = image
        }
      case .failure:
        DispatchQueue.main.async {
          self.image = self.placeholder
        }
      }
    }
  }
  
  func cancel() {
    imageTask?.cancel()
    imageTask = nil
  }
}

class StaticImageViewModel: ImageViewModelProtocol {
  
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
