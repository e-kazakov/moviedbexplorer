//
//  URLSessionAPIClient.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

struct MovieDBServerConfig {
  let apiBase: URL
  let imageBase: URL
  let apiKey: String
}

func createSession() -> URLSessionProtocol {
  let config = URLSessionConfiguration.default
  config.urlCache = createCache()
  config.requestCachePolicy = .reloadIgnoringLocalCacheData
  return URLSession(configuration: config)
}

func createCache() -> URLCache {
  let mem = 100 * 1024 * 1024
  let disk = 500 * 1024 * 1024
  return URLCache(memoryCapacity: mem, diskCapacity: disk, diskPath: "urlcache")
}

class URLSessionAPIClient: APIClient {

  private let urlSession: URLSessionProtocol
  
  private let serverConfig: MovieDBServerConfig

  static let apiKeyQueryItemName = "api_key"
  
  init(serverConfig: MovieDBServerConfig, urlSession: URLSessionProtocol) {
    self.serverConfig = serverConfig
    self.urlSession = urlSession
  }
  
  func posterURL(path: String, size: PosterSize) -> URL {
    return serverConfig.imageBase.appendingPathComponent(size.rawValue).appendingPathComponent(path)
  }
  
  @discardableResult
  func fetch<T>(resource: HTTPResource<T>, callback: @escaping (Result<T, APIError>) -> Void) -> Disposable {
    let isCancelled = Atomic(value: false)
    let task = urlSession.dataTask(
      with: request(for: resource),
      completionHandler: dataTaskCompletionHandler(resource: resource, isCancelled: isCancelled, callback: callback)
    )
    task.resume()
    
    return ClosureDisposable {
      isCancelled.set(true)
      task.cancel()
    }
  }
  
  private func dataTaskCompletionHandler<T>(
    resource: HTTPResource<T>,
    isCancelled: Atomic<Bool>,
    callback: @escaping (Result<T, APIError>) -> Void
  ) -> (Data?, URLResponse?, Error?) -> Void {
    return { data, response, error in
      guard !isCancelled.value else { return }
      
      if let error = error {
        callback(.failure(.network(inner: error)))
      } else {
        if let data = data {
          let parsingResult = resource.parse(data)
          callback(
            parsingResult.mapError({ .jsonMapping(inner: $0) })
          )
        } else {
          callback(.failure(.noData))
        }
      }
    }
  }
  
  private func request<T>(for resource: HTTPResource<T>) -> URLRequest {
    let request = configure(request: createRequest(for: resource))
    if let queryParams = resource.parameters {
      return queryParams.encode(in: request)
    } else {
      return request
    }
  }
  
  private func createRequest<T>(for resource: HTTPResource<T>) -> URLRequest {
    let url = serverConfig.apiBase.appendingPathComponent(resource.path)
    var request = URLRequest(url: url)
    request.httpMethod = resource.method.rawValue
    return request
  }
  
  private func configure(request: URLRequest) -> URLRequest {
    var req = request
    req.appendQueryItem(URLQueryItem(name: URLSessionAPIClient.apiKeyQueryItemName, value: serverConfig.apiKey))
    return req
  }
  
}

extension URLRequest {
  mutating func appendQueryItem(_ queryItem: URLQueryItem) {
    appendQueryItems([queryItem])
  }
  
  mutating func appendQueryItems<S>(_ queryItems: S) where S: Sequence, S.Element == URLQueryItem {
    url = url?.appendingQueryItems(queryItems)
  }
}

extension URL {
  
  func appendingQueryItems<S>(_ queryItems: S) -> URL where S: Sequence, S.Element == URLQueryItem {
    guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
      return self
    }
    
    var requestQueryItems = components.queryItems ?? []
    requestQueryItems.append(contentsOf: queryItems)
    components.queryItems = requestQueryItems
    
    return components.url ?? self
  }

}
