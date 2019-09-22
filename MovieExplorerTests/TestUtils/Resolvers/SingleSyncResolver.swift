//
//  SingleSyncResolver.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 30.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

class SingleSyncResolver<Params: Hashable, Res>: Resolver<Params, Res> {
  private let result: Res

  init(result: Res) {
    self.result = result
  }

  override func resolve(_ Params: Params, callback: @escaping (Res) -> Void) {
    callback(result)
  }
}
