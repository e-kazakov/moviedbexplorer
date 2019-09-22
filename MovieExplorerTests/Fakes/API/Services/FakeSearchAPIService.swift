//
//  FakeSearchAPIService.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 25.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation
@testable import MovieExplorer

class FakeSearchAPIService: SearchAPIService {
  
  typealias SearchResult = Result<APIPaginatedResponse<Movie>, APIError>
  struct SearchParameters: Hashable {
    let query: String
    let page: Int?
  }

  var searchResolver: Resolver<SearchParameters, SearchResult>?
  private(set) var searchInvocations: [SearchParameters] = []
  
  @discardableResult
  func search(query: String,
              page: Int?,
              callback: @escaping (Result<APIPaginatedResponse<Movie>, APIError>) -> Void) -> Disposable {

    let parameters = SearchParameters(query: query, page: page)
    
    let cancelled = Atomic(value: false)
    
    searchInvocations.append(parameters)
    searchResolver?.resolve(parameters) { result in
      guard !cancelled.value else { return }
      callback(result)
    }
    
    return ClosureDisposable { cancelled.set(true) }
  }
  
}
