//
//  MoviesList.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/14/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

struct MoviesListState {
  var status: LoadStatus
  var movies: [Movie]
  var hasMore: Bool
  
  static let initial = MoviesListState(status: .notLoaded, movies: [], hasMore: false)
}

protocol MoviesList {
  
  var store: Store<MoviesListState> { get }
  
  func loadNext()
}

class TMDBMoviesList: MoviesList {
  
  let store = Store<MoviesListState>(.initial)

  private var isFirstPageLoaded = false
  private var nextPage: Int? = nil
  private let api: APIClient

  init(api: APIClient) {
    self.api = api
  }
  
  func loadNext() {
    if isFirstPageLoaded {
      loadNextPage()
    } else {
      loadFirstPage()
    }
  }

  private func loadFirstPage() {
    load(page: nil)
  }
  
  private func loadNextPage() {
    guard let nextPage = nextPage else { return }
    load(page: nextPage)
  }

  private func load(page: Int?) {
    guard !store.state.status.isLoading else { return }
    
    startLoading()
    api.fetch(resource: MovieDBAPI.explore(page: page)) { [weak self] result in
      switch result {
      case .success(let paginatedResponse):
        self?.loaded(movies: paginatedResponse.results, nextPage: paginatedResponse.nextPage)
      case .failure(let error):
        self?.failedToLoad(with: error)
      }
    }
  }
  
  private func startLoading() {
    store.update { state in
      state.status = .loading
    }
  }
  
  private func loaded(movies: [Movie], nextPage: Int?) {
    self.nextPage = nextPage
    self.isFirstPageLoaded = true

    store.update { state in
      state.movies.append(contentsOf: movies)
      state.status = .loaded
      state.hasMore = nextPage != nil
    }
  }
  
  private func failedToLoad(with error: Error) {
    store.update { state in
      state.status = .error(error)
    }
  }

}
