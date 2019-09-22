//
//  MoviesSearch.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 07.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

struct MoviesSearchState {
  var recentSearches: [String]
  
  var status: LoadStatus
  var movies: [Movie]
  var hasMore: Bool
  
  static let initial = MoviesSearchState(
    recentSearches: [],
    status: .notLoaded,
    movies: [],
    hasMore:false
  )
}

protocol MoviesSearch {
  
  var store: Store<MoviesSearchState> { get }
  
  func search(query: String)
  func cancel()
  func loadNext()
}

class TMDBMoviesSearch: MoviesSearch {
  let store = Store<MoviesSearchState>(.initial)
  
  private let service: SearchAPIService
  private let recentSearchesRepository: RecentSearchesRepository
  private var searchTerm: String?
  private var isFirstPageLoaded = false
  private var nextPage: Int?
  private var fetchDisposable: Disposable?
  private let maxRecentSearchesCount: Int
  private static let defaultMaxRecentSearchesCount = 10
  
  init(service: SearchAPIService,
       recentSearchesRepository: RecentSearchesRepository,
       maxRecentSearchesCount: Int = TMDBMoviesSearch.defaultMaxRecentSearchesCount
  ) {
    self.service = service
    self.recentSearchesRepository = recentSearchesRepository
    self.maxRecentSearchesCount = maxRecentSearchesCount
    
    load()
  }
  
  private func load() {
    do {
      let recentSearches = try self.recentSearchesRepository.load()
      store.update { state in
        state.recentSearches = recentSearches
      }
    } catch {
      debugPrint("Failed to load search state. Error: \(error)")
    }
  }
  
  func search(query: String) {
    guard searchTerm != query else { return }
    
    cancelPreviousSearch()
    
    searchTerm = query
    
    loadFirstPage()
  }
  
  func cancel() {
    cancelPreviousSearch()
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
  
  private func cancelPreviousSearch() {
    searchTerm = nil
    nextPage = nil
    isFirstPageLoaded = false
    fetchDisposable?.dispose()
    fetchDisposable = nil
    
    store.update { state in
      state.movies = []
      state.status = .notLoaded
      state.hasMore = false
    }
  }
  
  private func load(page: Int?) {
    guard let query = self.searchTerm else {
      fatalError("Search query should be provided.")
    }
    guard !store.state.status.isLoading else { return }
    
    startLoading()
    fetchDisposable = service.search(query: query, page: page) { [weak self] result in
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

      if let searchTerm = self.searchTerm {
        state.recentSearches = update(recentSearches: state.recentSearches, withQuery: searchTerm)
      }
    }
    
    do {
      try recentSearchesRepository.save(store.state.recentSearches)
    } catch {
      debugPrint("Failed to persist recent searches. Error: \(error)")
    }
  }
  
  private func update(recentSearches: [String], withQuery query: String) -> [String] {
    var res = recentSearches
    if let idx = res.firstIndex(of: query) {
      res.remove(at: idx)
    }
    
    let countAfterUpdate = res.count + 1
    if countAfterUpdate > maxRecentSearchesCount {
      res.removeLast(countAfterUpdate - maxRecentSearchesCount)
    }
    
    return [query] + res
  }
  
  private func failedToLoad(with error: Error) {
    store.update { state in
      state.status = .error(error)
    }
  }
}
