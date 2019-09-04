//
//  DefaultsRecentSearchesRepositoryTests.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 7/23/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import XCTest
@testable import MovieExplorer

class DefaultsRecentSearchesRepositoryTests: XCTestCase {
  
  private let searchesKey = "movieexplorer.defaults.recent-searches"
  
  func test_Load_RetursValueFromDefaults() {
    // given
    let expected = ["Matrix", "Die hard"]
    let fakeDefaults = FakeUserDefaults()
    fakeDefaults.data[searchesKey] = expected

    let repository = DefaultsRecentSearchesRepository(defaults: fakeDefaults)
    
    // when
    let actual = try? repository.load()
    
    // then
    XCTAssertEqual(expected, actual)
  }
  
  func test_Save_SetsValueInDefaults() {
    // given
    let expected = ["Matrix", "Die hard"]
    let fakeDefaults = FakeUserDefaults()
    fakeDefaults.data[searchesKey] = expected
    
    let repository = DefaultsRecentSearchesRepository(defaults: fakeDefaults)
    
    // when
    try? repository.save(expected)
    let actual = fakeDefaults.stringArray(forKey: searchesKey)
    
    // then
    XCTAssertEqual(expected, actual)
  }
  
}
