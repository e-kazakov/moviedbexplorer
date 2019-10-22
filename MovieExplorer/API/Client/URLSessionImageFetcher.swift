//
//  URLSessionImageFetcher.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/19/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation
import class UIKit.UIImage

class URLSessionImageFetcher: ImageFetcher {
  
  private let urlSession: URLSessionProtocol
  private let serverConfig: MovieDBServerConfig
  private let cache: ImageCache
  
  init(serverConfig: MovieDBServerConfig, urlSession: URLSessionProtocol, cache: ImageCache) {
    self.serverConfig = serverConfig
    self.urlSession = urlSession
    self.cache = cache
  }
  
  func posterURL(path: String, size: PosterSize) -> URL {
    return serverConfig.imageBase.appendingPathComponent(size.rawValue).appendingPathComponent(path)
  }
  
  func fetch(from url: URL, callback: @escaping (Result<UIImage, APIError>) -> Void) -> Disposable {
    if let cached = cache.object(forKey: url as NSURL) {
      callback(.success(cached))
      return NoOpDisposable()
    }

    let request = URLRequest(url: url)
    let isCancelled = Atomic(value: false)

    let task = urlSession.dataTask(with: request) { [weak cache] data, response, error in
      guard !isCancelled.value else { return }
      
      if let error = error {
        callback(.failure(.network(inner: error)))
      } else if let data = data, let image = UIImage(data: data)?.decoded() {
        cache?.setObject(image, forKey: url as NSURL)
        callback(.success(image))
      } else {
        callback(.failure(.invalidResponse))
      }
    }
    task.resume()
    
    return ClosureDisposable {
      isCancelled.set(true)
      task.cancel()
    }
  }
}
