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
  
  static func explore(page: Int? = nil) -> HTTPResource<APIPaginatedRes<Movie>> {
    var queryParams: [String: String] = [:]
    queryParams[pageQueryParameter] = page.map(String.init)
    
    return HTTPResource(
      path: "discover/movie",
      method: .get,
      parameters: URLQueryParameters(queryParams),
      parse: mapObject
    )
  }
  
  static func search(query: String, page: Int? = nil) -> HTTPResource<APIPaginatedRes<Movie>> {
    var queryParams: [String: String] = [:]
    queryParams[pageQueryParameter] = page.map(String.init)
    queryParams["query"] = query
    
    return HTTPResource(
      path: "search/movie",
      method: .get,
      parameters: URLQueryParameters(queryParams),
      parse: mapObject
    )
  }
  
}
