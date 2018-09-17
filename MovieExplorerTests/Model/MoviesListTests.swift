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
    let stubClient = FakeAPIClient()
    let moviesList = TMDBMoviesList(api: stubClient)
    
    let state = moviesList.store.state
    XCTAssertTrue(state.status.isNotLoaded)
    XCTAssertEqual([], state.movies)
    XCTAssertFalse(state.hasMore)
  }
  
  func testLoadNext_Request_UpdatesLoadingState() {
    let stubClient = FakeAPIClient()
    let moviesList = TMDBMoviesList(api: stubClient)
    
    moviesList.loadNext()
    let state = moviesList.store.state
    
    XCTAssertTrue(state.status.isLoading)
  }
  
  func testLoadNext_SinglePage_UpdatesStateWithResponse() {
    let stubClient = FakeAPIClient()
    let moviesList = TMDBMoviesList(api: stubClient)
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    let stubResult = Result<APIPaginatedRes<Movie>, APIError>.success(stubResponse)
    stubClient.nextFetchResultResolver = { _ in stubResult }
    
    moviesList.loadNext()
    let state = moviesList.store.state
    
    XCTAssertFalse(state.hasMore)
    XCTAssertTrue(state.status.isLoaded)
    XCTAssertEqual(stubResponse.results, state.movies)
  }
  
  func testLoadNext_Multipage_UpdatesStateWithResponse() {
    let stubClient = FakeAPIClient()
    let moviesList = TMDBMoviesList(api: stubClient)
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 2
    )
    let stubResult = Result<APIPaginatedRes<Movie>, APIError>.success(stubResponse)
    stubClient.nextFetchResultResolver = { _ in stubResult }
    
    moviesList.loadNext()
    let state = moviesList.store.state
    
    XCTAssertTrue(state.hasMore)
    XCTAssertTrue(state.status.isLoaded)
    XCTAssertEqual(stubResponse.results, state.movies)
  }
  
  func testLoadNext_FailedResponse_ErrorStatus() {
    let stubClient = FakeAPIClient()
    let moviesList = TMDBMoviesList(api: stubClient)
    let stubResult = Result<APIPaginatedRes<Movie>, APIError>.failure(.noData)
    stubClient.nextFetchResultResolver = { _ in stubResult }

    moviesList.loadNext()
    let state = moviesList.store.state

    XCTAssertTrue(state.status.isError)
  }
  
  func testLoadNext_SecondLoadSinglePage_NoSecondFetch() {
    let stubClient = FakeAPIClient()
    let moviesList = TMDBMoviesList(api: stubClient)
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    let stubResult = Result<APIPaginatedRes<Movie>, APIError>.success(stubResponse)
    let stubResponseSecondCall = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random, Movie.random],
      totalResults: 2,
      totalPages: 1
    )
    let stubResultSecondCall = Result<APIPaginatedRes<Movie>, APIError>.success(stubResponseSecondCall)
    
    stubClient.nextFetchResultResolver = {_ in stubResult }
    
    moviesList.loadNext()

    stubClient.nextFetchResultResolver = { _ in stubResultSecondCall }
    moviesList.loadNext()
    
    let state = moviesList.store.state
    
    XCTAssertFalse(state.hasMore)
    XCTAssertTrue(state.status.isLoaded)
    XCTAssertEqual(stubResponse.results, state.movies)
  }
  
  func testLoadNext_SecondLoadMultiplePages_RequestsCorrectPage() {
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
    let stubResult = Result<APIPaginatedRes<Movie>, APIError>.success(stubResponse)
    let stubResponseSecondPage = APIPaginatedRes<Movie>(
      page: 2,
      results: [Movie.random],
      totalResults: 2,
      totalPages: 2
    )
    let stubResultSecondPage = Result<APIPaginatedRes<Movie>, APIError>.success(stubResponseSecondPage)
    stubClient.nextFetchResultResolver = { resource in
      switch resource {
      case firstPageResource: return stubResult
      case secondPageResource: return stubResultSecondPage
      default: return nil
      }
    }
    
    moviesList.loadNext()
    moviesList.loadNext()
    
    let state = moviesList.store.state
    
    XCTAssertFalse(state.hasMore)
    XCTAssertTrue(state.status.isLoaded)
    XCTAssertEqual(stubResponse.results + stubResponseSecondPage.results, state.movies)
  }
 
}

extension Movie {
  static var random: Movie {
    return Movie(
      id: Int(arc4random()),
      posterPath: UUID().uuidString,
      title: UUID().uuidString,
      releaseDate: UUID().uuidString,
      overview: UUID().uuidString
    )
  }
}
