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
  
  private var moviesList: TMDBMoviesList!
  private var fakeAPIClient: FakeAPIClient!
  
  override func setUp() {
    super.setUp()
    
    fakeAPIClient = FakeAPIClient()
    moviesList = TMDBMoviesList(api: fakeAPIClient)
  }
  
  override func tearDown() {
    fakeAPIClient = nil
    moviesList = nil
    
    super.tearDown()
  }
  
  // MARK: Init tests
  
  func testInit_InitialState() {
    // given

    // when
    let moviesList = TMDBMoviesList(api: FakeAPIClient())
    let state = moviesList.store.state
    
    // then
    XCTAssertTrue(state.status.isNotLoaded)
    XCTAssertEqual([], state.movies)
    XCTAssertFalse(state.hasMore)
  }
  
  // MARK: LoadNext initial load tests
  
  func testLoadNext_Request_SetsLoadingState() {
    // given

    // when
    moviesList.loadNext()
    let state = moviesList.store.state
    
    // then
    XCTAssertTrue(state.status.isLoading)
  }
  
  func testLoadNext_Response_SetsLoadedState() {
    // given
    let stubResponse = make_singlepageResponse()
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))

    // when
    moviesList.loadNext()
    let state = moviesList.store.state
    
    // then
    XCTAssertTrue(state.status.isLoaded)
  }
  
  func testLoadNext_Response_UpdatesMovies() {
    // given
    let stubResponse = make_singlepageResponse()
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))

    let expectedMovies = stubResponse.results

    // when
    moviesList.loadNext()
    let state = moviesList.store.state
    
    // then
    XCTAssertEqual(expectedMovies, state.movies)
  }
  
  func testLoadNext_SinglePageResponse_HasMoreReturnsFalse() {
    // given
    let stubResponse = make_singlepageResponse()
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
    // when
    moviesList.loadNext()
    let state = moviesList.store.state
    
    // then
    XCTAssertFalse(state.hasMore)
  }
  
  func testLoadNext_MultipageFirstPageResponse_HasMoreReturnsTrue() {
    // given
    let stubResponse = make_multipageResponseFirstPage()
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
    // when
    moviesList.loadNext()
    let state = moviesList.store.state
    
    // then
    XCTAssertTrue(state.hasMore)
  }
  
  func testLoadNext_FailedResponse_UpdatesStateWithErrorStatus() {
    // given
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .failure(.noData))

    // when
    moviesList.loadNext()
    let state = moviesList.store.state

    // then
    XCTAssertTrue(state.status.isError)
  }
  
  // MARK: LoadNext subsequent load tests
  
  func testLoadNext_SecondLoadSinglepage_NoSecondFetch() {
    // given
    let resourceFirstPage = MovieDBAPI.explore().asTestResource
    let resourceSecondPage = MovieDBAPI.explore(page: 2).asTestResource
    let responseFirstPage = make_singlepageResponse()
    let responseSecondPage = make_multipageResponseFirstPage()
    
    fakeAPIClient.nextFetchResultResolver = SyncFakeAPIClientResultResolver(results: [
      resourceFirstPage: .success(responseFirstPage),
      resourceSecondPage: .success(responseSecondPage),
    ])
    
    let expectedMovies = responseFirstPage.results
    
    // when
    moviesList.loadNext()
    moviesList.loadNext()
    
    let state = moviesList.store.state
    
    // then
    XCTAssertEqual(expectedMovies, state.movies)
  }
  
  func testLoadNext_SecondLoadMultipage_SetsLoadingState() {
    // given
    let resourceFirstPage = MovieDBAPI.explore().asTestResource
    let responseFirstPage = make_multipageResponseFirstPage()
    
    fakeAPIClient.nextFetchResultResolver = SyncFakeAPIClientResultResolver(results: [
      resourceFirstPage: .success(responseFirstPage),
    ])
    
    // when
    moviesList.loadNext()
    moviesList.loadNext()
    
    let state = moviesList.store.state
    
    // then
    XCTAssertTrue(state.status.isLoading)
  }

  func testLoadNext_LastLoadMultipage_HasMoreReturnsFalse() {
    // given
    let resourceFirstPage = MovieDBAPI.explore().asTestResource
    let resourceSecondPage = MovieDBAPI.explore(page: 2).asTestResource
    let responseFirstPage = make_multipageResponseFirstPage()
    let responseSecondPage = make_multipageResponseSecondPage()
    
    fakeAPIClient.nextFetchResultResolver = SyncFakeAPIClientResultResolver(results: [
      resourceFirstPage: .success(responseFirstPage),
      resourceSecondPage: .success(responseSecondPage),
    ])
    
    // when
    moviesList.loadNext()
    moviesList.loadNext()
    
    let state = moviesList.store.state
    
    // then
    XCTAssertFalse(state.hasMore)
  }
  
  func testLoadNext_SecondLoadMultipage_AppendsMovies() {
    // given
    let resourceFirstPage = MovieDBAPI.explore().asTestResource
    let resourceSecondPage = MovieDBAPI.explore(page: 2).asTestResource
    let responseFirstPage = make_multipageResponseFirstPage()
    let responseSecondPage = make_multipageResponseSecondPage()
    
    fakeAPIClient.nextFetchResultResolver = SyncFakeAPIClientResultResolver(results: [
      resourceFirstPage: .success(responseFirstPage),
      resourceSecondPage: .success(responseSecondPage),
    ])
    
    let expectedMovies = responseFirstPage.results + responseSecondPage.results
    
    // when
    moviesList.loadNext()
    moviesList.loadNext()
    
    let state = moviesList.store.state
    
    // then
    XCTAssertEqual(expectedMovies, state.movies)
  }
 
}

// MARK: - Factories

private func make_singlepageResponse() -> APIPaginatedRes<Movie> {
  return APIPaginatedRes<Movie>(
    page: 1,
    results: [Movie.random],
    totalResults: 1,
    totalPages: 1
  )
}

private func make_multipageResponseFirstPage() -> APIPaginatedRes<Movie> {
  return APIPaginatedRes<Movie>(
    page: 1,
    results: [Movie.random],
    totalResults: 2,
    totalPages: 2
  )
}

private func make_multipageResponseSecondPage() -> APIPaginatedRes<Movie> {
  return APIPaginatedRes<Movie>(
    page: 2,
    results: [Movie.random],
    totalResults: 2,
    totalPages: 2
  )
}
