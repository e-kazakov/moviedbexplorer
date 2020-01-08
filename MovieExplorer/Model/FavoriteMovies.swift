//
//  FavoriteMovies.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 20.08.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

struct FavoriteMoviesState {
  var movies: [Movie]
  var ids: Set<Int>
  
  static let initial = FavoriteMoviesState(movies: [], ids: [])
}

extension FavoriteMoviesState {
  mutating func add(movie: Movie) {
    movies.insert(movie, at: movies.startIndex)
    ids.insert(movie.id)
  }
  
  mutating func remove(movie: Movie) {
    movies.remove(movie)
    ids.remove(movie.id)
  }
  
  func isFavorite(_ movie: Movie) -> Bool {
    return ids.contains(movie.id)
  }
  
  func isFavorite(id: Int) -> Bool {
    return ids.contains(id)
  }
}

protocol FavoriteMovies {
  var store: Store<FavoriteMoviesState> { get }
  
  func toggleFavorite(movie: Movie)
}

class TMDBFavoriteMovies: FavoriteMovies {
  
  let store = Store<FavoriteMoviesState>(.initial)
  
  private let repository: FavoriteMoviesRepository
  
  init(repository: FavoriteMoviesRepository) {
    self.repository = repository
    
    load()
  }
  
  func toggleFavorite(movie: Movie) {
    store.update { state in
      do {
        if state.isFavorite(movie) {
          try repository.removeBy(id: movie.id)
          state.remove(movie: movie)
        } else {
          try repository.save(movie)
          state.add(movie: movie)
        }
      } catch {
        // FIXME: wtf
      }
    }
  }
  
  private func load() {
    store.update { state in
      let loaded = repository.movies()
      state.movies = loaded.reversed()
      state.ids = Set(loaded.map { $0.id })
    }
  }
}
