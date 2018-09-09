//
//  MovieMappingTests.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import XCTest
@testable import MovieExplorer

class MovieMappingTests: XCTestCase {
  
  func test_ValidMovieJSON_SuccessfullyParsed() {
    do {
      let decoder = JSONDecoder()
      let jsonData = try ResourceReader().read(named: "movie", with: "json")
      _ = try decoder.decode(Movie.self, from: jsonData)
    } catch {
      XCTFail("Failed to parse movie json. \(error)")
    }
  }

}
