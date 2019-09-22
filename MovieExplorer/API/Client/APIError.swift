//
//  APIError.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

enum APIError: Error {
  case invalidResponse
  case parsing(inner: ParsingError)
  case network(inner: Error?)
  case unknown(inner: Error?)
}


extension APIError {
  var isCancelledRequestError: Bool {
    guard
      case .network(let innerNetworkError) = self,
      let networkError = innerNetworkError.map({ $0 as NSError })
      else {
        return false
      }
    
    return networkError.domain == NSURLErrorDomain && networkError.code == NSURLErrorCancelled
  }
}
