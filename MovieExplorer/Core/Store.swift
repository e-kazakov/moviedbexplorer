//
//  Store.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/14/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol SubscriptionToken {
  mutating func dispose()
}

class Store<State> {
  
  private(set) var state: State
  
  private var stateObservers: [UUID: (State) -> Void] = [:]
  
  init(_ initialState: State) {
    self.state = initialState
  }
  
  func observe(_ observer: @escaping (State) -> Void) -> SubscriptionToken {
    let uid = UUID()
    stateObservers[uid] = observer
    
    return ClosureSubscriptionToken { [weak self] in
      self?.stateObservers[uid] = nil
    }
  }

  func update(_ updateClosure: (inout State) -> Void) {
    updateClosure(&state)
    notifyStateObservers()
  }
    
  private func notifyStateObservers() {
    stateObservers.values.forEach(notify)
  }
  
  private func notify(observer: (State) -> Void) {
    observer(state)
  }

}

struct ClosureSubscriptionToken: SubscriptionToken {
  
  private var disposeBlock: (() -> Void)?
  
  init(_ disposeBlock: @escaping () -> Void) {
    self.disposeBlock = disposeBlock
  }
  
  mutating func dispose() {
    disposeBlock?()
    disposeBlock = nil
  }
}

extension Store {
  func observe(on targetQueue: DispatchQueue, _ observer: @escaping (State) -> Void) -> SubscriptionToken {
    return observe { state in
      targetQueue.async { observer(state) }
    }
  }
}
