//
//  FakeFavoriteMoviesRepository.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 02.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation
@testable import MovieExplorer

class FakeFavoriteMoviesRepository: FavoriteMoviesRepository {

  var moviesStorage: [Movie]

  init(movies: [Movie] = []) {
    moviesStorage = movies
  }
  
  func movies() -> [Movie] {
    return moviesStorage
  }
  
  func save(_ movie: Movie) throws {
    moviesStorage.append(movie)
  }
  
  func removeBy(id movieId: Int) throws {
    moviesStorage.removeAll { $0.id == movieId }
  }

}
