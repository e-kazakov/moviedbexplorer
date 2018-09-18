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
  
  private var imageTask: URLSessionTask?
  
  init(url: URL, placeholder: UIImage? = nil) {
    self.url = url
    self.placeholder = placeholder
  }
  
  func load() {
    guard imageTask == nil else { return }
    imageTask = URLSession.shared.dataTask(with: url) { data, response, error in
      if let data = data {
        let image = UIImage(data: data)?.decoded()
        DispatchQueue.main.async { self.image = image }
      }
    }
    imageTask?.resume()
  }
  
  func cancel() {
    imageTask?.cancel()
    imageTask = nil
  }
}
