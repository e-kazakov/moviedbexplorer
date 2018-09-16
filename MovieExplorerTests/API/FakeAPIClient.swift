//
//  FakeAPIClient.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 9/15/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation
@testable import MovieExplorer

class FakeAPIClient: APIClient {
  
  let baseURL = URL(string: "https://unittest.com")!
  
  var lastResource: Any?
  
  var nextFetchResultResolverForPath: ((String) -> Any?)?
  var nextFetchResultResolver: ((TestHTTPResource) -> Any?)?

  func posterURL(path: String, size: PosterSize) -> URL {
    return baseURL.appendingPathComponent(size.rawValue).appendingPathComponent(path)
  }
  
  func fetch<T>(resource: HTTPResource<T>, callback: @escaping (Result<T, APIError>) -> Void) {
    lastResource = resource
    if let result = nextFetchResultResolver?(resource.asTestResource) as? Result<T, APIError> {
      callback(result)
    }
  }

}

struct TestHTTPResource: Equatable {
  let path: String
  let method: HTTPMethod
  let parameters: HTTPResourceParameters?
  
  static func == (lhs: TestHTTPResource, rhs: TestHTTPResource) -> Bool {
    return lhs.path == rhs.path
      && lhs.method == rhs.method
      && equalParameters(lhs.parameters, rhs.parameters)
  }
  
  private static func equalParameters(_ lhs: HTTPResourceParameters?, _ rhs: HTTPResourceParameters?) -> Bool {
    if let lhs = lhs, let rhs = rhs {
      return lhs.equals(other: rhs)
    } else {
      return true
    }
  }
}

extension HTTPResource {
  var asTestResource: TestHTTPResource {
    return TestHTTPResource(path: path, method: method, parameters: parameters)
  }
}
