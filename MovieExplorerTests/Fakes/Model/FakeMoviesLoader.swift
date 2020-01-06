//
//  FakeMoviesLoader.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 1/7/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import Foundation

@testable import MovieExplorer

class FakeMoviesLoader: MoviesLoader {
  
  typealias LoadResult = Result<APIPaginatedResponse<Movie>, APIError>
  struct LoadParameters: Hashable {
    let page: Int?
  }

  var loadResolver: Resolver<LoadParameters, LoadResult>?
  private(set) var loadInvocations: [LoadParameters] = []
  
  @discardableResult
  func load(
    page: Int?,
    callback: @escaping (Result<APIPaginatedResponse<Movie>, APIError>) -> Void
  ) -> Disposable {
    
    let parameters = LoadParameters(page: page)
    
    let cancelled = Atomic(value: false)
    
    loadInvocations.append(parameters)
    loadResolver?.resolve(parameters) { result in
      guard !cancelled.value else { return }
      callback(result)
    }
    
    return ClosureDisposable { cancelled.set(true) }
  }
}
