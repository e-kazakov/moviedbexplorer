//
//  FakeRecentSearchesRepository.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 7/23/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation
@testable import MovieExplorer

class FakeRecentSearchesRepository: RecentSearchesRepository {
  
  var searches: [String] = []
  var nextLoadError: Error?
  var nextSaveError: Error?
  
  func load() throws -> [String] {
    if let error = nextLoadError {
      throw error
    }
    
    return searches
  }
  
  func save(_ searches: [String]) throws {
    if let error = nextSaveError {
      throw error
    }
    
    self.searches = searches
  }
  
}
