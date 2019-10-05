//
//  MVECompatible.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 16.06.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation.NSObject

struct MVE<Base> {
  let base: Base
}

protocol MVECompatible {
  associatedtype Base
  
  static var mve: MVE<Base>.Type { get }
  var mve: MVE<Base> { get }
}

extension MVECompatible {
  static var mve: MVE<Self>.Type {
    return MVE<Self>.self
  }
  
  var mve: MVE<Self> {
    return MVE(base: self)
  }
}

extension NSObject: MVECompatible { }
