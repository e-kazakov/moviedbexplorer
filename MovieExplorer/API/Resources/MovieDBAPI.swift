//
//  MovieDBAPI.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

struct MovieDBAPI {
  
  private init() { }
  
  private static let pageQueryParameter = "page"
  private static let searchQueryParameter = "query"
  
  static func explore(page: Int? = nil) -> HTTPResource<APIPaginatedResponse<Movie>> {
    var queryParams: [String: String] = [:]
    queryParams[pageQueryParameter] = page.map(String.init)
    
    return HTTPResource(
      path: "3/discover/movie",
      method: .get,
      parameters: URLQueryParameters(queryParams),
      parse: mapJSON
    )
  }
  
  static func search(query: String, page: Int? = nil) -> HTTPResource<APIPaginatedResponse<Movie>> {
    var queryParams: [String: String] = [:]
    queryParams[pageQueryParameter] = page.map(String.init)
    queryParams[searchQueryParameter] = query
    
    return HTTPResource(
      path: "3/search/movie",
      method: .get,
      parameters: URLQueryParameters(queryParams),
      parse: mapJSON
    )
  }
  
}
