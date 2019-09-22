//
//  SearchAPIService.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 22.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol SearchAPIService {
  
  @discardableResult
  func search(query: String,
              page: Int?,
              callback: @escaping (Result<APIPaginatedResponse<Movie>, APIError>) -> Void) -> Disposable
  
}

class SearchAPIServiceImpl: SearchAPIService {
  
  private let client: APIClient
  
  private let pageQueryParameter = "page"
  private let searchQueryParameter = "query"

  init(client: APIClient) {
    self.client = client
  }
  
  @discardableResult
  func search(query: String,
              page: Int?,
              callback: @escaping (Result<APIPaginatedResponse<Movie>, APIError>) -> Void) -> Disposable {
    
    let request = searchRequeset(query: query, page: page)
    return client.fetch(request: request, callback: callback)
  }
  
  private func searchRequeset(query: String, page: Int?) -> URLRequest {
    var queryParams: [String: String] = [:]
    queryParams[pageQueryParameter] = page.map(String.init)
    queryParams[searchQueryParameter] = query

    var req = URLRequest(path: "3/search/movie")
    req.appendQueryItems(queryParams.map(URLQueryItem.init))
    
    return req
  }
  
}
