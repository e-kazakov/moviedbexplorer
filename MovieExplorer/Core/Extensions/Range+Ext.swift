//
//  Range+Ext.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/19/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

extension Range where Bound: Strideable, Bound.Stride: SignedInteger {
  func generate<T>(_ generator: () -> T) -> [T] {
    map { _ in generator() }
  }
}
