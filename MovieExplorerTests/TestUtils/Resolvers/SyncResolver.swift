//
//  SyncResolver.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 30.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

class SyncResolver<Params: Hashable, Res>: Resolver<Params, Res> {
  typealias Callback = (Params) -> Void

  private var results: [Params: Res]

  init(results: [Params: Res] = [:]) {
    self.results = results
  }

  subscript(request: Params) -> Res? {
    get {
      return results[request]
    }
    set {
      results[request] = newValue
    }
  }

  override func resolve(_ Params: Params, callback: @escaping (Res) -> Void) {
    if let result = self[Params] {
      callback(result)
    }
  }
}
