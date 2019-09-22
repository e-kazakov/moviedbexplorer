//
//  AsyncResolver.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 30.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

class AsyncResolver<Params: Hashable, Res>: Resolver<Params, Res> {
  
  typealias Callback = (Res) -> Void
  
  private var requests: [(Params, Callback)] = []
  private var results: [Params: Res]

  init(results: [Params: Res] = [:]) {
    self.results = results
  }
  
  subscript(Params: Params) -> Res? {
    get {
      return results[Params]
    }
    set {
      results[Params] = newValue
    }
  }
  
  func executeAll() {
    execute(requests: requests)
    
    requests = []
  }
  
  func execute(for Params: Params) {
    let stubbedRequests = requests.filter { (res, _) -> Bool in
      return res == Params
    }
    
    execute(requests: stubbedRequests)
    
    requests.removeAll { (res, _) -> Bool in
      res == Params
    }
  }
  
  private func execute(requests: [(Params, Callback)]) {
    requests.forEach { (Params, callback) in
      if let result = self[Params] {
        callback(result)
      }
    }
  }
  
  override func resolve(_ Params: Params, callback: @escaping (Res) -> Void) {
    requests.append((Params, callback))
  }
}
