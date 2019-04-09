//
//  MoviesListViewModel.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/18/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

enum MoviesListViewModelStatus {
  case initial
  case loading
  case loaded
  case failedToLoad
  case loadingNext
  case failedToLoadNext
}

protocol MoviesListViewModel {
  var status: MoviesListViewModelStatus { get }
  var movies: [MovieCellViewModel] { get }
  
  var onChanged: (() -> Void)? { get set }
  var onGoToDetails: ((Movie) -> Void)? { get set }
  
  func loadNext()
  func retry()
}

class MoviesListViewModelImpl: MoviesListViewModel {
  
  private(set) var status: MoviesListViewModelStatus
  private(set) var movies: [MovieCellViewModel] = []
  private var moviesById: [Int: MovieCellViewModel] = [:]
  
  var onChanged: (() -> Void)?
  var onGoToDetails: ((Movie) -> Void)?
  
  private let moviesList: MoviesList
  private let apiClient: APIClient
  private let imageFetcher: ImageFetcher
  private var subscriptionToken: SubscriptionToken?
  
  deinit {
    subscriptionToken?.dispose()
  }
  
  init(moviesList: MoviesList, api: APIClient, imageFetcher: ImageFetcher) {
    self.moviesList = moviesList
    self.apiClient = api
    self.imageFetcher = imageFetcher
    subscriptionToken = nil
    status = .initial
    
    subscriptionToken = moviesList.store.observe(on: DispatchQueue.main) { [weak self] state in
      self?.update(with: state)
    }
  }
  
  func loadNext() {
    moviesList.loadNext()
  }
  
  func retry() {
    moviesList.loadNext()
  }
  
  private func update(with state: MoviesListState) {
    update(movies: state)
    update(status: state)
    
    onChanged?()
  }
  
  private func update(movies state: MoviesListState) {
    var movies: [MovieCellViewModel] = []
    for movie in state.movies {
      let movieVM = moviesById[movie.id] ?? createMovieViewModel(movie)
      moviesById[movie.id] = movieVM
      movies.append(movieVM)
    }
    self.movies = movies
  }
  
  private func createMovieViewModel(_ movie: Movie) -> MovieCellViewModel {
    let vm = MovieCellViewModelImpl(movie: movie, api: apiClient, imageFetcher: imageFetcher)
    vm.onSelect = { [weak self] in self?.onGoToDetails?(movie) }
    return vm
  }
  
  private func update(status state: MoviesListState) {
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
}
