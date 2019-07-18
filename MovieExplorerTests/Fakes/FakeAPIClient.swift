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

typealias ResolverResult = AnyValueResult<APIError>

protocol FakeAPIClientResultResolving {
  func resolve(for resource: TestHTTPResource, callback: @escaping (ResolverResult) -> Void)
}

class FakeAPIClient: APIClient {
  
  let baseURL = URL(string: "https://unittest.com")!
  
  var requestsCount = 0
  var lastResource: TestHTTPResource?
  
  var nextFetchResultResolver: FakeAPIClientResultResolving?

  func posterURL(path: String, size: PosterSize) -> URL {
    return baseURL.appendingPathComponent(size.rawValue).appendingPathComponent(path)
  }
  
  @discardableResult
  func fetch<T>(resource: HTTPResource<T>, callback: @escaping (Result<T, APIError>) -> Void) -> Disposable {
    lastResource = resource.asTestResource
    requestsCount += 1
    
    var cancelled = false
    if let resolver = self.nextFetchResultResolver {
      resolver.resolve(for: resource.asTestResource) { result in
        guard !cancelled else { return }
        callback(result.specialized())
      }
    }
    
    return ClosureDisposable { cancelled = true }
  }

}

// MARK: - HTTPResources

struct TestHTTPResource: Equatable, Hashable {
  let path: String
  let method: HTTPMethod
  let parameters: HTTPResourceParameters?
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(path)
    hasher.combine(method)
    parameters?.hash(into: &hasher)
  }
  
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

// MARK: - Result Resolvers

class AsyncFakeAPIClientResultResolver: FakeAPIClientResultResolving {

  typealias Callback = (ResolverResult) -> Void
  
  private var requests: [(TestHTTPResource, Callback)] = []
  private var results: [TestHTTPResource: AnyValueResult<APIError>]
  
  init(results: [TestHTTPResource: AnyValueResult<APIError>] = [:]) {
    self.results = results
  }

  subscript(resource: TestHTTPResource) -> AnyValueResult<APIError>? {
    get {
      return results[resource]
    }
    set {
      results[resource] = newValue
    }
  }
  
  func executeAll() {
    execute(requests: requests)
    
    requests = []
  }
  
  func execute(for resource: TestHTTPResource) {
    let resourceRequests = requests.filter { (res, _) -> Bool in
      return res == resource
    }
    
    execute(requests: resourceRequests)
    
    requests.removeAll { (res, _) -> Bool in
      res == resource
    }
  }
  
  private func execute(requests: [(TestHTTPResource, Callback)]) {
    requests.forEach { (resource, callback) in
      if let result = self[resource] {
        callback(result)
      }
    }
  }

  func resolve(for resource: TestHTTPResource, callback: @escaping (ResolverResult) -> Void) {
    requests.append((resource, callback))
  }
}

class SyncFakeAPIClientResultResolver: FakeAPIClientResultResolving {
  
  typealias Callback = (ResolverResult) -> Void
  
  private var results: [TestHTTPResource: AnyValueResult<APIError>]
  
  init(results: [TestHTTPResource: AnyValueResult<APIError>] = [:]) {
    self.results = results
  }
  
  subscript(resource: TestHTTPResource) -> AnyValueResult<APIError>? {
    get {
      return results[resource]
    }
    set {
      results[resource] = newValue
    }
  }
  
  func resolve(for resource: TestHTTPResource, callback: @escaping (ResolverResult) -> Void) {
    if let result = self[resource] {
      callback(result)
    }
  }
}

class SingleSyncFakeAPIClientResultResolver: FakeAPIClientResultResolving {
  
  private let result: ResolverResult
  
  init(result: ResolverResult) {
    self.result = result
  }
  
  func resolve(for resource: TestHTTPResource, callback: (ResolverResult) -> Void) {
    callback(result)
  }
}

//class ClosureSyncFakeAPIClientResultResolver: FakeAPIClientResultResolving {
//
//  typealias ClosureResolver = (TestHTTPResource) -> ResolverResult?
//
//  private let resolver: ClosureResolver
//
//  init(resolver: @escaping ClosureResolver) {
//    self.resolver = resolver
//  }
//
//  func resolve<T>(for resource: HTTPResource<T>, callback: (ResolverResult) -> Void) {
//    if let result = resolver(resource.asTestResource) {
//      callback(result)
//    }
//  }
//}

class NoOpFakeAPIClientResultResolver: FakeAPIClientResultResolving {
  func resolve(for resource: TestHTTPResource, callback: (ResolverResult) -> Void) {
    // no-op
  }
}

