//
//  MovieSearchViewModel.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 07.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol MovieSearchViewModel {

  var searchQuery: String? { get }
  var status: MoviesListViewModelStatus { get }
  var movies: [MovieCellViewModel] { get }
  var recentSearches: [String] { get }

  var onChanged: (() -> Void)? { get set }
  var onGoToDetails: ((Movie) -> Void)? { get set }
  
  func search(query: String)
  func cancel()
  func loadNext()
  func retry()
  
}

class MovieSearchViewModelImpl: MovieSearchViewModel {
  private(set) var searchQuery: String?
  private(set) var status: MoviesListViewModelStatus = .initial
  private(set) var movies: [MovieCellViewModel] = []
  private(set) var recentSearches: [String] = []
  private var moviesById: [Int: MovieCellViewModel] = [:]
  
  var onChanged: (() -> Void)?
  var onGoToDetails: ((Movie) -> Void)?
  
  private let moviesSearch: MoviesSearch
  private let imageFetcher: ImageFetcher
  private var disposable: Disposable?
  
  deinit {
    disposable?.dispose()
  }
  
  init(moviesSearch: MoviesSearch, imageFetcher: ImageFetcher) {
    self.moviesSearch = moviesSearch
    self.imageFetcher = imageFetcher
    
    update(with: moviesSearch.store.state)
    
    disposable = moviesSearch.store.observe(on: DispatchQueue.main) { [weak self] state in
      self?.update(with: state)
    }
  }
  
  func search(query: String) {
    let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
    searchQuery = query
    moviesSearch.search(query: trimmedQuery)
  }
  
  func cancel() {
    moviesSearch.cancel()
  }
  
  func loadNext() {
    guard status != .failedToLoadNext else { return }
    
    moviesSearch.loadNext()
  }
  
  func retry() {
    moviesSearch.loadNext()
  }
  
  private func update(with state: MoviesSearchState) {
    update(movies: state)
    update(status: state)
    update(recentSearches: state)
    
    onChanged?()
  }
  
  private func update(movies state: MoviesSearchState) {
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
  
  private func update(status state: MoviesSearchState) {
    switch state.status {
    case .notLoaded:
      status = .initial
    case .loaded:
      status = .loaded
    case .loading:
      status = state.movies.isEmpty ? .loading : .loadingNext
    case .error:
      status = state.movies.isEmpty ? .failedToLoad : .failedToLoadNext
    }
  }
  
  private func update(recentSearches state: MoviesSearchState) {
    recentSearches = state.recentSearches
  }
}
