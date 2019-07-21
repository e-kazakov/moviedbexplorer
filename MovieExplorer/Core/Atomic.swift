//
//  Atomic.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 21.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

class Atomic<Value> {
  
  var value: Value {
    get {
      return syncQueue.sync { storedValue }
    }
  }
  
  private var storedValue: Value
  private let syncQueue = DispatchQueue(label: "Atomic sync queue")
  
  init(value: Value) {
    storedValue = value
  }
  
  func mutate(_ update: (Value) -> Value) {
    syncQueue.sync {
      storedValue = update(storedValue)
    }
  }
  
  func set(_ value: Value) {
    mutate { _ in value }
  }
}
