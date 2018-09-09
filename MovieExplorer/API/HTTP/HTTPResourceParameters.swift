//
//  APIResourceParameters.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

typealias HTTPParametersEncoder = (URLRequest) -> URLRequest

protocol HTTPResourceParameters {
  func encode(in request: URLRequest) -> URLRequest
}

struct URLQueryParameters: HTTPResourceParameters {
  
  let queryParameters: [String: String]
  
  init(_ queryParameters: [String: String]) {
    self.queryParameters = queryParameters
  }
  
  func encode(in request: URLRequest) -> URLRequest {
    
    var req = request
    req.appendQueryItems(queryParameters.map(URLQueryItem.init))

    return req
  }
}
