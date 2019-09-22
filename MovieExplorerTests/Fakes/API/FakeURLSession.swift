//
//  FakeURLSession.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 9/9/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation
@testable import MovieExplorer

class FakeURLSession: URLSessionProtocol {
  
  struct DataTaskResult {
    let data: Data?
    let urlResponse: URLResponse?
    let error: Error?

    static let empty = DataTaskResult()

    init(data: Data? = nil, urlResponse: URLResponse? = nil, error: Error? = nil) {
      self.data = data
      self.urlResponse = urlResponse
      self.error = error
    }
  }
  typealias DataTaskParameters = URLRequest

  var nextDataTask = FakeURLSessionDataTask()
  var dataTaskResolver: Resolver<DataTaskParameters, DataTaskResult>?
  private(set) var dataTaskInvocations: [DataTaskParameters] = []

  func dataTask(
    with request: URLRequest,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTaskProtocol {
    dataTaskInvocations.append(request)
    
    dataTaskResolver?.resolve(request) { response in
      completionHandler(response.data, response.urlResponse, response.error)
    }
    
    return nextDataTask
  }
}
