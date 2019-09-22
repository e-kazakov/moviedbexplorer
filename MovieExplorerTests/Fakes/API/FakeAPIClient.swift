//
//  FakeAPIClient.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 9/15/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation
@testable import MovieExplorer

typealias AnyValueResult<TError: Error> = Result<Any, TError>

extension Result {
  var asAnyValue: AnyValueResult<Failure> {
    switch self {
    case .success(let value):
      return .success(value)
    case .failure(let error):
      return .failure(error)
    }
  }
}

extension Result where Success == Any {
  func specialized<T>() -> Result<T, Failure> {
    return map { $0 as! T }
  }
}

protocol FakeAPIClientFetchResultResolver {
  func resolve(for request: URLRequest, callback: @escaping (AnyValueResult<APIError>) -> Void)
}

class FakeAPIClient: APIClient {
  
  let baseURL = URL(string: "https://unittest.com")!
  
  typealias FetchResult = AnyValueResult<APIError>
  typealias FetchParameters = URLRequest
  
  var fetchResolver: Resolver<FetchParameters, FetchResult>?
  private(set) var fetchInvocations: [FetchParameters] = []
  
  var nextFetchResultResolver: FakeAPIClientFetchResultResolver?

  @discardableResult
  func fetch<T>(request: URLRequest,
                callback: @escaping (Result<T, APIError>) -> Void) -> Disposable where T : Decodable {
    
    fetchInvocations.append(request)

    var cancelled = false
    fetchResolver?.resolve(request) { result in
      guard !cancelled else { return }
      callback(result.specialized())
    }
    
    return ClosureDisposable { cancelled = true }
  }

  @discardableResult
  func fetch(request: URLRequest,
             callback: @escaping (Result<Void, APIError>) -> Void) -> Disposable {

    fetchInvocations.append(request)

    var cancelled = false
    fetchResolver?.resolve(request) { result in
      guard !cancelled else { return }
      callback(result.specialized())
    }
    
    return ClosureDisposable { cancelled = true }
  }

}
