//
//  DiscoverAPIService.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 22.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol DiscoverAPIService {
  
  @discardableResult
  func discover(page: Int?,
                callback: @escaping (Result<APIPaginatedResponse<Movie>, APIError>) -> Void) -> Disposable
  
}

class DiscoverAPIServiceImpl: DiscoverAPIService {
  
  private let client: APIClient

  private let pageQueryParameter = "page"

  init(client: APIClient) {
    self.client = client
  }
  
  @discardableResult
  func discover(page: Int?, callback: @escaping (Result<APIPaginatedResponse<Movie>, APIError>) -> Void) -> Disposable {
    
    let request = discoverRequest(page: page)
    return client.fetch(request: request, callback: callback)
  }
  
  private func discoverRequest(page: Int?) -> URLRequest {
    var queryParams: [String: String] = [:]
    queryParams[pageQueryParameter] = page.map(String.init)
    
    var req = URLRequest(path: "3/discover/movie")
    req.appendQueryItems(queryParams.map(URLQueryItem.init))
    
    return req
  }
  
}
