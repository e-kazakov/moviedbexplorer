//
//  Store.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/14/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

class Store<State> {
  
  private(set) var state: State
  
  private var stateObservers: [UUID: (State) -> Void] = [:]
  
  init(_ initialState: State) {
    self.state = initialState
  }
  
  func observe(_ observer: @escaping (State) -> Void) -> Disposable {
    let uid = UUID()
    stateObservers[uid] = observer
    
    return ClosureDisposable { [weak self] in
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

extension Store {
  func observe(on targetQueue: DispatchQueue, _ observer: @escaping (State) -> Void) -> Disposable {
    return observe { state in
      targetQueue.async { observer(state) }
    }
  }
}
