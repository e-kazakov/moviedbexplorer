//
//  Disposable.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 07.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol Disposable {
  
  var isDisposed: Bool { get }
  
  mutating func dispose()
}

struct ClosureDisposable: Disposable {
  
  var isDisposed: Bool {
    return disposeBlock == nil
  }
  
  private var disposeBlock: (() -> Void)?
  
  init(_ disposeBlock: @escaping () -> Void) {
    self.disposeBlock = disposeBlock
  }
  
  mutating func dispose() {
    disposeBlock?()
    disposeBlock = nil
  }
}
