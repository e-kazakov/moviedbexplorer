//
//  MoviesListTests.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 9/15/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import XCTest
@testable import MovieExplorer

class MoviesListTests: XCTestCase {
  
  func testInit_NotLoadedState() {
    // given
    let stubClient = FakeAPIClient()
    
    // when
    let moviesList = TMDBMoviesList(api: stubClient)
    let state = moviesList.store.state
    
    // then
    XCTAssertTrue(state.status.isNotLoaded)
    XCTAssertEqual([], state.movies)
    XCTAssertFalse(state.hasMore)
  }
  
  // MARK: LoadNext initial load tests
  
  func testLoadNext_Request_SetsLoadingState() {
    // given
    let stubClient = FakeAPIClient()
    let moviesList = TMDBMoviesList(api: stubClient)
    
    // when
    moviesList.loadNext()
    let state = moviesList.store.state
    
    // then
    XCTAssertTrue(state.status.isLoading)
  }
  
  func testLoadNext_SinglePage_UpdatesStateWithResponse() {
    // given
    let stubClient = FakeAPIClient()
    let moviesList = TMDBMoviesList(api: stubClient)
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    stubClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
    let expectedMovies = stubResponse.results
    
    // when
    moviesList.loadNext()
    let state = moviesList.store.state
    
    // then
    XCTAssertFalse(state.hasMore)
    XCTAssertTrue(state.status.isLoaded)
    XCTAssertEqual(expectedMovies, state.movies)
  }
  
  func testLoadNext_Multipage_UpdatesStateWithResponse() {
    // given
    let stubClient = FakeAPIClient()
    let moviesList = TMDBMoviesList(api: stubClient)
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 2
    )
    stubClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
    let expectedMovies = stubResponse.results
    
    // when
    moviesList.loadNext()
    let state = moviesList.store.state
    
    // then
    XCTAssertTrue(state.hasMore)
    XCTAssertTrue(state.status.isLoaded)
    XCTAssertEqual(expectedMovies, state.movies)
  }
  
  func testLoadNext_FailedResponse_UpdatesStateWithErrorStatus() {
    // given
    let stubClient = FakeAPIClient()
    let moviesList = TMDBMoviesList(api: stubClient)
    stubClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .failure(.noData))

    // when
    moviesList.loadNext()
    let state = moviesList.store.state

    // then
    XCTAssertTrue(state.status.isError)
  }
  
  // MARK: LoadNext subsequent load tests
  
  func testLoadNext_SecondLoadSinglePage_NoSecondFetch() {
    // given
    let stubClient = FakeAPIClient()
    let moviesList = TMDBMoviesList(api: stubClient)
    let firstPageResource = MovieDBAPI.explore().asTestResource
    let secondPageResource = MovieDBAPI.explore(page: 2).asTestResource
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    let stubResponseSecondCall = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random, Movie.random],
      totalResults: 2,
      totalPages: 1
    )
    
    stubClient.nextFetchResultResolver = SyncFakeAPIClientResultResolver(results: [
      firstPageResource: .success(stubResponse),
      secondPageResource: .success(stubResponseSecondCall),
    ])
    
    let expectedMovies = stubResponse.results
    
    // when
    moviesList.loadNext()
    moviesList.loadNext()
    
    let state = moviesList.store.state
    
    // then
    XCTAssertFalse(state.hasMore)
    XCTAssertTrue(state.status.isLoaded)
    XCTAssertEqual(expectedMovies, state.movies)
  }
  
  func testLoadNext_SecondLoadMultiplePages_RequestsCorrectPage() {
    // given
    let stubClient = FakeAPIClient()
    let moviesList = TMDBMoviesList(api: stubClient)
    let firstPageResource = MovieDBAPI.explore().asTestResource
    let secondPageResource = MovieDBAPI.explore(page: 2).asTestResource
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 2,
      totalPages: 2
    )
    let stubResponseSecondPage = APIPaginatedRes<Movie>(
      page: 2,
      results: [Movie.random],
      totalResults: 2,
      totalPages: 2
    )
    
    stubClient.nextFetchResultResolver = SyncFakeAPIClientResultResolver(results: [
      firstPageResource: .success(stubResponse),
      secondPageResource: .success(stubResponseSecondPage),
    ])
    
    // when
    moviesList.loadNext()
    moviesList.loadNext()
    
    let state = moviesList.store.state
    
    // then
    XCTAssertFalse(state.hasMore)
    XCTAssertTrue(state.status.isLoaded)
    XCTAssertEqual(stubResponse.results + stubResponseSecondPage.results, state.movies)
  }
 
}
