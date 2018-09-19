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
  
  private let session: URLSessionProtocol
  
  init(session: URLSessionProtocol) {
    self.session = session
  }
  
  func fetch(from url: URL, callback: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTaskProtocol {
    let request = URLRequest(url: url)
    let task = session.dataTask(with: request) { data, response, error in
      if let error = error {
        callback(.failure(.network(inner: error)))
      } else {
        if let data = data {
          callback(.success(data))
        } else {
          callback(.failure(.noData))
        }
      }
    }
    task.resume()
    return task
  }

}
