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

class URLSessionAPIClient: APIClient {

  static let apiKeyQueryItemName = "api_key"

  private let urlSession: URLSessionProtocol
  private let serverConfig: MovieDBServerConfig
  
  init(serverConfig: MovieDBServerConfig, urlSession: URLSessionProtocol) {
    self.serverConfig = serverConfig
    self.urlSession = urlSession
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
        let parsingResult = resource.parse(data).mapError(APIError.parsing(inner:))
        callback(parsingResult)
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
