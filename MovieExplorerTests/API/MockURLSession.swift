//
//  URLSessionMock.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 9/9/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation
@testable import MovieExplorer

class MockURLSession: URLSessionProtocol {

  var nextResponse = MockResponse.empty
  var nextDataTask = MockURLSessionDataTask()
  private(set) var lastRequest: URLRequest?
  
  func dataTask(
    with request: URLRequest,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTaskProtocol {
    lastRequest = request
    
    completionHandler(nextResponse.data, nextResponse.urlResponse, nextResponse.error)
    
    return nextDataTask
  }
}

struct MockResponse {
  
  static let empty = MockResponse()
  
  let data: Data?
  let urlResponse: URLResponse?
  let error: Error?
  
  init(data: Data? = nil, urlResponse: URLResponse? = nil, error: Error? = nil) {
    self.data = data
    self.urlResponse = urlResponse
    self.error = error
  }
  
}
