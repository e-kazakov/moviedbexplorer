//
//  URLSessionProtocol.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/9/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
  func dataTask(
    with request: URLRequest,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
  func resume()
//  func cancel()
}

extension URLSession: URLSessionProtocol {
  func dataTask(
    with request: URLRequest,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTaskProtocol {
    return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
  }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
