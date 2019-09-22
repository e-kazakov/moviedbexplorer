//
//  FavoritesViewModel.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 28.08.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation


protocol FavoritesViewModel: class {
  var movies: [MovieCellViewModel] { get }
  
  var onChanged: (() -> Void)? { get set }
  var onGoToDetails: ((Movie) -> Void)? { get set }
}

class FavoritesViewModelImpl: FavoritesViewModel {
  
  private(set) var movies: [MovieCellViewModel] = []
  private var moviesById: [Int: MovieCellViewModel] = [:]
  
  var onChanged: (() -> Void)?
  var onGoToDetails: ((Movie) -> Void)?
  
  private let favorites: FavoriteMovies
  private let imageFetcher: ImageFetcher
  private var disposable: Disposable?
  
  deinit {
    disposable?.dispose()
  }
  
  init(favorites: FavoriteMovies, imageFetcher: ImageFetcher) {
    self.favorites = favorites
    self.imageFetcher = imageFetcher
    
    update(with: favorites.store.state)
    
    disposable = favorites.store.observe(on: DispatchQueue.main) { [weak self] state in
      self?.update(with: state)
    }
  }
  
  private func update(with state: FavoriteMoviesState) {
    update(movies: state)
    
    onChanged?()
  }
  
  private func update(movies state: FavoriteMoviesState) {
    var movies: [MovieCellViewModel] = []
    for movie in state.movies {
      let movieVM = moviesById[movie.id] ?? createMovieViewModel(movie)
      moviesById[movie.id] = movieVM
      movies.append(movieVM)
    }
    self.movies = movies
  }
  
  private func createMovieViewModel(_ movie: Movie) -> MovieCellViewModel {
    let vm = MovieCellViewModelImpl(movie: movie, imageFetcher: imageFetcher)
    vm.onSelect = { [weak self] in self?.onGoToDetails?(movie) }
    return vm
  }
}
