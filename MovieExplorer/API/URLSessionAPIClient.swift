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
}

enum PosterSize: String {
  case w92 = "w92"
  case w185 = "w185"
  case w500 = "w500"
  case w780 = "w780"
}

class URLSessionAPIClient: APIClient {

  private let urlSession: URLSession
  
  private let apiKey = "8ce5ac519ae011454741f33c416274e2"
  
  private let apiKeyQueryItemName = "api_key"
  
  private let apiBase: URL
  private let imageBase: URL
  
  init(apiBase: URL, imageBase: URL, urlSession: URLSession) {
    self.apiBase = apiBase
    self.imageBase = imageBase
    self.urlSession = urlSession
  }
  
  func posterURL(path: String, size: PosterSize) -> URL {
    return imageBase.appendingPathComponent(size.rawValue).appendingPathComponent(path)
  }
  
  func fetch<T>(resource: HTTPResource<T>, callback: @escaping (Result<T, APIError>) -> Void) {
    let task = urlSession.dataTask(
      with: request(for: resource),
      completionHandler: dataTaskCompletionHandler(resource: resource, callback: callback)
    )
    task.resume()
  }
  
  private func dataTaskCompletionHandler<T>(
    resource: HTTPResource<T>,
    callback: @escaping (Result<T, APIError>) -> Void
  ) -> (Data?, URLResponse?, Error?) -> Void {
    return { data, response, error in
      if let error = error {
        callback(.failure(.unknown(inner: error)))
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
    let url = apiBase.appendingPathComponent(resource.path)
    let configuredRequest = configure(request: URLRequest(url: url))
    if let queryParams = resource.parameters {
      return queryParams.encode(in: configuredRequest)
    } else {
      return configuredRequest
    }
  }
  
  private func configure(request: URLRequest) -> URLRequest {
    var req = request
    req.appendQueryItem(URLQueryItem(name: apiKeyQueryItemName, value: apiKey))
    return req
  }
  
}

extension URLRequest {
  mutating func appendQueryItem(_ queryItem: URLQueryItem) {
    guard let url = self.url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      return
    }

    var requestQueryItems = components.queryItems ?? []
    requestQueryItems.append(queryItem)
    components.queryItems = requestQueryItems
    
    self.url = components.url
  }
  
  mutating func appendQueryItems<S>(_ queryItems: S) where S: Sequence, S.Element == URLQueryItem {
    guard let url = self.url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      return
    }
    
    var requestQueryItems = components.queryItems ?? []
    requestQueryItems.append(contentsOf: queryItems)
    components.queryItems = requestQueryItems
    
    self.url = components.url
  }
}
