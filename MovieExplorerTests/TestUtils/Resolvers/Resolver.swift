//
//  Resolver.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 30.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

class Resolver<Params: Hashable, Res> {
  
  func resolve(_ Params: Params, callback: @escaping (Res) -> Void) {
    fatalError("Should be implemented in subclass")
  }
  
}
