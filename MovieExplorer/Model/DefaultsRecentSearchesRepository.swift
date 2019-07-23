//
//  DefaultsRecentSearchesRepository.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 7/23/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol UserDefaultsProtocol {
  func stringArray(forKey defaultName: String) -> [String]?
  func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol { }

class DefaultsRecentSearchesRepository: RecentSearchesRepository {
  
  private let defaults: UserDefaultsProtocol
  private let searchesKey = "movieexplorer.defaults.recent-searches"
  
  init(defaults: UserDefaultsProtocol) {
    self.defaults = defaults
  }
  
  func load() throws -> [String] {
    return defaults.stringArray(forKey: searchesKey) ?? []
  }
  
  func save(_ searches: [String]) throws {
    defaults.set(searches, forKey: searchesKey)
  }
  
}
