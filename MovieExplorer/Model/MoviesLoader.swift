//
//  MoviesLoader.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 1/6/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol MoviesLoader {
  @discardableResult
  func load(page: Int?,
            callback: @escaping (Result<APIPaginatedResponse<Movie>, APIError>) -> Void) -> Disposable
}

class ExploreMoviesLoader: MoviesLoader {
  
  private let service: DiscoverAPIService
  
  init(service: DiscoverAPIService) {
    self.service = service
  }
  
  
  @discardableResult
  func load(page: Int?,
            callback: @escaping (Result<APIPaginatedResponse<Movie>, APIError>) -> Void) -> Disposable {
    service.discover(page: page, callback: callback)
  }
}

class SimilarMoviesLoader: MoviesLoader {

  private let moviedId: Int
  private let service: MovieDetailsAPIService

  init(moviedId: Int, service: MovieDetailsAPIService) {
    self.moviedId = moviedId
    self.service = service
  }
  
  @discardableResult
  func load(page: Int?,
            callback: @escaping (Result<APIPaginatedResponse<Movie>, APIError>) -> Void) -> Disposable {
    service.similar(id: moviedId, page: page, callback: callback)
  }
}

class RecommendedMoviesLoader: MoviesLoader {

  private let moviedId: Int
  private let service: MovieDetailsAPIService

  init(moviedId: Int, service: MovieDetailsAPIService) {
    self.moviedId = moviedId
    self.service = service
  }
  
  @discardableResult
  func load(page: Int?,
            callback: @escaping (Result<APIPaginatedResponse<Movie>, APIError>) -> Void) -> Disposable {
    service.recommendations(id: moviedId, page: page, callback: callback)
  }
}
