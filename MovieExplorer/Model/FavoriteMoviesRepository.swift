//
//  FavoriteMoviesRepository.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 28.08.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol FavoriteMoviesRepository {
  
  func movies() -> [Movie]
  func save(_ movie: Movie) throws
  func removeBy(id movieId: Int) throws
  
}
