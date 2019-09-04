//
//  JSONFavoriteMoviesRepositoryTests.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 02.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import XCTest
@testable import MovieExplorer

class JSONFavoriteMoviesRepositoryTests: XCTestCase {
  
  private var fakeFileStorage: FakeFileStorage!
  private var repository: JSONFavoriteMoviesRepository!
  
  override func setUp() {
    super.setUp()
    
    fakeFileStorage = FakeFileStorage()
    repository = JSONFavoriteMoviesRepository(fileStorage: fakeFileStorage)
  }
  
  override func tearDown() {
    super.tearDown()
    
    fakeFileStorage = nil
    repository = nil
  }

  // MARK: Movies tests
  
  func testMovies_EmptyStorage_ReturnsEmptyList() {
    // given
    
    // when
    let actualMovies = repository.movies()
    
    // then
    XCTAssertTrue(actualMovies.isEmpty)
  }

  func testMovies_NonEmptyStorage_ReturnsLoadedList() throws {
    // given
    let movie1 = Movie.random
    let expectedMovies = [movie1]
    
    let writerRepository = JSONFavoriteMoviesRepository(fileStorage: fakeFileStorage)
    try writerRepository.save(movie1)

    // when
    let actualMovies = repository.movies()
    
    // then
    XCTAssertEqual(expectedMovies, actualMovies)
  }
  
  func testMovies_RandomData_ReturnsEmptyList() {
    // given
    fakeFileStorage.data = Data(repeating: 1, count: 1)
    
    // when
    let actualMovies = repository.movies()
    
    // then
    XCTAssertTrue(actualMovies.isEmpty)
  }

  // MARK: Movies tests

  func testSave_Movie_UpdatesStorage() throws {
    // given
    let movie = Movie.random

    // when
    try repository.save(movie)

    // then
    XCTAssertNotNil(fakeFileStorage.data)
  }
  
  func testSave_TwoMovies_PreservesOrder() throws {
    // given
    let movie1 = Movie.random
    let movie2 = Movie.random
    let expectedMovies = [movie1, movie2]
    
    // when
    try repository.save(movie1)
    try repository.save(movie2)
    let actualMovies = repository.movies()
    
    // then
    XCTAssertEqual(expectedMovies, actualMovies)
  }

  // MARK: Movies tests

  func testRemove_Movie_UpdatesStorage() throws {
    // given
    let movie = Movie.random
    try repository.save(movie)
    fakeFileStorage.data = nil

    // when
    try repository.removeBy(id: movie.id)
    
    // then
    XCTAssertNotNil(fakeFileStorage.data)
  }
  
  func testRemove_Movie_MoviesReturnsUpdatesList() throws {
    // given
    let movie1 = Movie.random
    let movie2 = Movie.random
    try repository.save(movie1)
    try repository.save(movie2)

    let expectedMovies = [movie1]

    // when
    try repository.removeBy(id: movie2.id)
    let actualMovies = repository.movies()
    
    // then
    XCTAssertEqual(expectedMovies, actualMovies)
  }
  
}
