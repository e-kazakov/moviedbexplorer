//
//  RemoteImageViewModel.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/18/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation
import class UIKit.UIImage

protocol RemoteImageViewModelProtocol: class {
  var placeholder: UIImage? { get }
  var image: UIImage? { get }
  
  var onChanged: (() -> Void)? { get set }
  
  func load()
  func cancel()
}

class RemoteImageViewModel: RemoteImageViewModelProtocol {
  
  let placeholder: UIImage?
  private(set) var image: UIImage? {
    didSet {
      onChanged?()
    }
  }
  
  var onChanged: (() -> Void)?
  
  private let url: URL
  
  private var imageTask: URLSessionDataTaskProtocol?
  
  private let fetcher: ImageFetcher
  
  init(url: URL, placeholder: UIImage? = nil, fetcher: ImageFetcher) {
    self.url = url
    self.placeholder = placeholder
    self.fetcher = fetcher
  }
  
  func load() {
    guard imageTask == nil else { return }
    imageTask = fetcher.fetch(from: url) { result in
      switch result {
      case .success(let data):
        let image = UIImage(data: data)?.decoded()
        DispatchQueue.main.async {
          self.image = image
        }
      case .failure(let error):
        if !error.isCancelledRequestError {
          print("Failed to load remote image. \(error)")
        }
      }
    }
  }
  
  func cancel() {
    imageTask?.cancel()
    imageTask = nil
  }
}
