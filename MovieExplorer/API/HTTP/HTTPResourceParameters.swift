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
  
  func equals(other: HTTPResourceParameters) -> Bool
}

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

}
