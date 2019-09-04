//
//  FavoriteMoviesTests.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 02.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import XCTest
@testable import MovieExplorer

class FavoriteMoviesTests: XCTestCase {
 
  private var favorites: TMDBFavoriteMovies!
  private var fakeFavoritesRepository: FakeFavoriteMoviesRepository!
  
  override func setUp() {
    super.setUp()
    
    fakeFavoritesRepository = FakeFavoriteMoviesRepository()
    favorites = TMDBFavoriteMovies(repository: fakeFavoritesRepository)
  }
  
  override func tearDown() {
    super.tearDown()
    
    fakeFavoritesRepository = nil
    favorites = nil
  }
  
  // MARK: Init tests
  
  func testInit_LoadsFavoriteMovies() {
    // given
    let movies = [Movie.random, Movie.random]
    let moviesIds = Set(movies.map({ $0.id }))
    let fakeFavoritesRepository = FakeFavoriteMoviesRepository(movies: movies)

    // when
    let favorites = TMDBFavoriteMovies(repository: fakeFavoritesRepository)

    // then
    XCTAssertEqual(movies, favorites.store.state.movies)
    XCTAssertEqual(moviesIds, favorites.store.state.ids)
  }
  
  // MARK: Toggle tests

  func testToggleFavorite_NotFavoriteMovie_UpdatesStateWithTheMovie() {
    // given
    let movie = Movie.random
    let expectedFavoriteMovies = [movie]
    
    // when
    favorites.toggleFavorite(movie: movie)
    let actualFavoriteMovies = favorites.store.state.movies
    
    // then
    XCTAssertEqual(expectedFavoriteMovies, actualFavoriteMovies)
  }

  func testToggleFavorite_NotFavoriteMovie_SavesTheMovieInRepository() {
    // given
    let movie = Movie.random
    let expectedSavedMovies = [movie]
    
    // when
    favorites.toggleFavorite(movie: movie)
    let actualSavedMovies = fakeFavoritesRepository.moviesStorage
    
    // then
    XCTAssertEqual(expectedSavedMovies, actualSavedMovies)
  }
  
  func testToggleFavorite_FavoriteMovie_UpdatesStateWithRemovesMovie() {
    // given
    let movie = Movie.random
    let expectedFavorites: [Movie] = []
    
    // when
    favorites.toggleFavorite(movie: movie)
    favorites.toggleFavorite(movie: movie)
    let actualFavotites = favorites.store.state.movies
    
    // then
    XCTAssertEqual(expectedFavorites, actualFavotites)
  }

  func testToggleFavorite_FavoriteMovie_RemovesTheMovieFromRepository() {
    // given
    let movie = Movie.random
    let expectedSavedMovies: [Movie] = []
    
    // when
    favorites.toggleFavorite(movie: movie)
    favorites.toggleFavorite(movie: movie)
    let actualSavedMovies = fakeFavoritesRepository.moviesStorage

    // then
    XCTAssertEqual(expectedSavedMovies, actualSavedMovies)

  }
  
}
