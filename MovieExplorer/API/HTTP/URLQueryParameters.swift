//
//  URLQueryParameters.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 7/23/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

struct URLQueryParameters: HTTPResourceParameters, Equatable {
  
  let queryParameters: [String: String]
  
  init(_ queryParameters: [String: String]) {
    self.queryParameters = queryParameters
  }
  
  func encode(in request: URLRequest) -> URLRequest {
    
    var req = request
    req.appendQueryItems(queryParameters.map(URLQueryItem.init))
    
    return req
  }
  
  func equals(other: HTTPResourceParameters) -> Bool {
    guard let other = other as? URLQueryParameters else { return false }
    
    return other == self
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(queryParameters)
  }
}
