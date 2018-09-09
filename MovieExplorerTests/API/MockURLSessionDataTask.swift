//
//  MockURLSessionDataTask.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 9/9/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation
@testable import MovieExplorer

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
  
  private(set) var isResumed = false
  
  func resume() {
    isResumed = true
  }
  
}
