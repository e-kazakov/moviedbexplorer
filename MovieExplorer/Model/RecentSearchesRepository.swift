//
//  RecentSearchesRepository.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 7/23/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol RecentSearchesRepository {
  
  func load() throws -> [String]
  func save(_ searches: [String]) throws
  
}
