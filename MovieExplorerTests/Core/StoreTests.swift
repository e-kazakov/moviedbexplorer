//
//  StoreTests.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 9/15/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import XCTest
@testable import MovieExplorer

class StoreTests: XCTestCase {
  
  func testInit_PassInitialState_InitializedWithProvidedState() {
    let state = State(value: 42)
    let store = Store<State>(state)
    
    XCTAssertEqual(state, store.state)
  }
  
  func testUpdate_ModifyState_UpdatesWrappedState() {
    let store = Store<State>(State(value: 0))
    
    store.update { state in
      state.value = 42
    }
    
    let expectedState = State(value: 42)
    let actualState = store.state
    XCTAssertEqual(expectedState, actualState)
  }
  
  func testObserve_UpdateState_NotifiesObserverWithNewState() {
    let store = Store<State>(State(value: 42))

    let expectedState = State(value: 0)
    let exp = expectation(description: "Observer")
    _ = store.observe { newState in
      exp.fulfill()
      XCTAssertEqual(expectedState, newState)
    }
    
    store.update { $0.value = 0 }
    
    waitForExpectations(timeout: 1)
  }
  
  func testObserve_AddSecondObserver_NotifiesBothObservers() {
    let store = Store<State>(State(value: 42))
    
    let exp = expectation(description: "Observer 1")
    _ = store.observe { _ in
      exp.fulfill()
    }
    let exp2 = expectation(description: "Observer 2")
    _ = store.observe { _ in
      exp2.fulfill()
    }
    
    store.update { $0.value = 0 }

    waitForExpectations(timeout: 1)
  }
  
  func testObserve_DisposeToken_RemovesSubscription() {
    let store = Store<State>(State(value: 42))
    var token = store.observe { _ in
      XCTFail()
    }
    token.dispose()
    store.update { $0.value = 0 }
  }
  
}

private struct State: Equatable {
  var value: Int
}
