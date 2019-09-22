//
//  SingleAsyncResolver.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 30.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

class SingleAsyncResolver<Params: Hashable, Res>: Resolver<Params, Res> {
  override func resolve(_ Params: Params, callback: @escaping (Res) -> Void) {
  }
}
