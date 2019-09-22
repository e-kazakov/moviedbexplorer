//
//  FakeDiscoverAPIService.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 25.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation
@testable import MovieExplorer

class FakeDisoverAPIService: DiscoverAPIService {
  
  typealias DiscoverResult = Result<APIPaginatedResponse<Movie>, APIError>
  struct DiscoverParameters: Hashable {
    let page: Int?
  }

  var discoverResolver: Resolver<DiscoverParameters, DiscoverResult>?
  private(set) var discoverInvocations: [DiscoverParameters] = []
  
  @discardableResult
  func discover(page: Int?,
                callback: @escaping (Result<APIPaginatedResponse<Movie>, APIError>) -> Void) -> Disposable {
    
    let parameters = DiscoverParameters(page: page)
 
    let cancelled = Atomic(value: false)
    
    discoverInvocations.append(parameters)
    discoverResolver?.resolve(parameters) { result in
      guard !cancelled.value else { return }
      callback(result)
    }
    
    return ClosureDisposable { cancelled.set(true) }
  }
  
}
