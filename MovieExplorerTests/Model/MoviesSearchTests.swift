//
//  MoviesSearchTests.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 12.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import XCTest
@testable import MovieExplorer

class MoviesSearchTests: XCTestCase {
  
  // MARK: Init tests
  
  func testInit_NotLoadedState() {
    // given
    let stubClient = FakeAPIClient()
    
    // when
    let moviesSearch = TMDBMoviesSearch(api: stubClient)
    let state = moviesSearch.store.state

    // then
    XCTAssertTrue(state.status.isNotLoaded)
    XCTAssertEqual([], state.movies)
    XCTAssertEqual([], state.recentSearches)
    XCTAssertFalse(state.hasMore)
  }
  
  // MARK: Search tests
  
  func testSearch_Request_SetsLoadingState() {
    // given
    let stubClient = FakeAPIClient()
    let moviesSearch = TMDBMoviesSearch(api: stubClient)
    
    let query = "dummy query"
    
    // when
    moviesSearch.search(query: query)
    let state = moviesSearch.store.state
    
    // then
    XCTAssertTrue(state.status.isLoading)
  }
  
  func testSeach_SecondCallSameQuery_DoesNothing() {
    // given
    let stubClient = FakeAPIClient()
    let moviesSearch = TMDBMoviesSearch(api: stubClient)

    let query = "dummy query"
    let expectedRequestsCount = 1
    
    // when
    moviesSearch.search(query: query)
    moviesSearch.search(query: query)
    
    // then
    XCTAssertEqual(expectedRequestsCount, stubClient.requestsCount)
  }
  
  func testSearch_SinglePage_UpdatesStateWithResponse() {
    // given
    let stubClient = FakeAPIClient()
    let moviesSearch = TMDBMoviesSearch(api: stubClient)

    let query = "dummy query"
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    stubClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
    // when
    moviesSearch.search(query: query)
    let state = moviesSearch.store.state
    
    // then
    XCTAssertFalse(state.hasMore)
    XCTAssertTrue(state.status.isLoaded)
    XCTAssertEqual(stubResponse.results, state.movies)
  }
  
  func testSearch_Error_UpdatesStateWithError() {
    // given
    let stubClient = FakeAPIClient()
    let moviesSearch = TMDBMoviesSearch(api: stubClient)

    let query = "dummy query"
    let error = APIError.unknown(inner: TestAPIError.anError)
    stubClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .failure(error))

    // when
    moviesSearch.search(query: query)
    let state = moviesSearch.store.state
    
    // then
    XCTAssertTrue(state.status.isError)
    XCTAssertFalse(state.hasMore)
    XCTAssertEqual([], state.movies)
    XCTAssertEqual([], state.recentSearches)
  }
  
  func testSearch_Multipage_UpdatesStateWithResponse() {
    // given
    let stubClient = FakeAPIClient()
    let moviesSearch = TMDBMoviesSearch(api: stubClient)

    let query = "dummy query"
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 2
    )
    stubClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
    // when
    moviesSearch.search(query: query)
    let state = moviesSearch.store.state
    
    // then
    XCTAssertTrue(state.hasMore)
    XCTAssertTrue(state.status.isLoaded)
    XCTAssertEqual(stubResponse.results, state.movies)
  }
  
  func testSearch_SecondCallDifferentQuery_ClearsPreviousSearch() {
    // given
    let stubClient = FakeAPIClient()
    let moviesSearch = TMDBMoviesSearch(api: stubClient)
    
    let query = "dummy query"
    let otherQuery = "other dummy query"
    
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    let firstSearchResource = MovieDBAPI.search(query: query).asTestResource
    stubClient.nextFetchResultResolver = SyncFakeAPIClientResultResolver(results: [
      firstSearchResource: .success(stubResponse)
    ])

    // when
    moviesSearch.search(query: query)
    moviesSearch.search(query: otherQuery)
    let state = moviesSearch.store.state
    
    // then
    XCTAssertTrue(state.status.isLoading)
    XCTAssertEqual([], state.movies)
    XCTAssertEqual([query], state.recentSearches)
    XCTAssertFalse(state.hasMore)
  }
  
  func testSearch_SecondCallDifferentQuery_UpdatesRecentSearches() {
    // given
    let stubClient = FakeAPIClient()
    let moviesSearch = TMDBMoviesSearch(api: stubClient)
    
    let query = "dummy query"
    let otherQuery = "other dummy query"
    
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    let firstSearchResource = MovieDBAPI.search(query: query).asTestResource
    let secondSearchResource = MovieDBAPI.search(query: otherQuery).asTestResource
    stubClient.nextFetchResultResolver = SyncFakeAPIClientResultResolver(results: [
      firstSearchResource: .success(stubResponse),
      secondSearchResource: .success(stubResponse)
    ])
    
    // when
    moviesSearch.search(query: query)
    moviesSearch.search(query: otherQuery)
    let state = moviesSearch.store.state
    
    // then
    XCTAssertEqual([otherQuery, query], state.recentSearches)
  }
  
  func testSearch_FirstSearchFetchFinishesAfterSecondSearchStarted_DoesNotUpdateStateWithFirstFetchResults() {
    // given
    let stubClient = FakeAPIClient()
    let moviesSearch = TMDBMoviesSearch(api: stubClient)
    
    let query = "dummy query"
    let otherQuery = "other dummy query"
    
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    let firstSearchResource = MovieDBAPI.search(query: query).asTestResource
    let resolver = AsyncFakeAPIClientResultResolver(results: [
      firstSearchResource: .success(stubResponse)
    ])
    stubClient.nextFetchResultResolver = resolver

    // when
    moviesSearch.search(query: query)
    moviesSearch.search(query: otherQuery)
    resolver.execute(for: firstSearchResource)
    let state = moviesSearch.store.state
    
    // then
    XCTAssertTrue(state.status.isLoading)
    XCTAssertEqual([], state.movies)
    XCTAssertEqual([], state.recentSearches)
    XCTAssertFalse(state.hasMore)
  }
  
  // MARK: LoadNext tests
  
  func testLoadNext_SecondLoadSinglePage_DoesNothing() {
    // given
    let stubClient = FakeAPIClient()
    let moviesSearch = TMDBMoviesSearch(api: stubClient)
    
    let query = "dummy query"
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    stubClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))

    // when
    moviesSearch.search(query: query)
    moviesSearch.loadNext()
    let state = moviesSearch.store.state

    // then
    XCTAssertFalse(state.hasMore)
    XCTAssertTrue(state.status.isLoaded)
    XCTAssertEqual(stubResponse.results, state.movies)
  }

  func testLoadNext_SecondLoadMultiPage_RequestsCorrectPage() {
    // given
    let stubClient = FakeAPIClient()
    let moviesSearch = TMDBMoviesSearch(api: stubClient)
    
    let query = "dummy query"
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 2,
      totalPages: 2
    )
    stubClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))

    let expectedResource = MovieDBAPI.search(query: query, page: 2).asTestResource
    
    // when
    moviesSearch.search(query: query)
    moviesSearch.loadNext()
    let requestedResource = stubClient.lastResource!

    // then
    XCTAssertEqual(expectedResource, requestedResource)
  }
  
  func testLoadNext_SecondLoadWhileFirstNotFinished_DoesNothing() {
    // given
    let stubClient = FakeAPIClient()
    let moviesSearch = TMDBMoviesSearch(api: stubClient)
    
    let query = "dummy query"
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    let searchResource = MovieDBAPI.search(query: query).asTestResource
    let resolver = AsyncFakeAPIClientResultResolver(results: [
      searchResource: .success(stubResponse)
    ])
    stubClient.nextFetchResultResolver = resolver
    
    let expectedRequestsCount = 1

    // when
    moviesSearch.search(query: query)
    moviesSearch.loadNext()
    
    // then
    XCTAssertEqual(expectedRequestsCount, stubClient.requestsCount)
  }
  
  // MARK: Cancel tests
  
  func testCancel_AfterSuccessfulSearch_ResetsState() {
    // given
    let stubClient = FakeAPIClient()
    let moviesSearch = TMDBMoviesSearch(api: stubClient)
    
    let query = "dummy query"
    
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    stubClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
    // when
    moviesSearch.search(query: query)
    moviesSearch.cancel()
    let state = moviesSearch.store.state
    
    // then
    XCTAssertTrue(state.status.isNotLoaded)
    XCTAssertEqual([], state.movies)
    XCTAssertEqual([query], state.recentSearches)
    XCTAssertFalse(state.hasMore)
  }
  
  func testCancel_FetchCompletesAfter_DoesNotUpdateStateWithResults() {
    // given
    let stubClient = FakeAPIClient()
    let moviesSearch = TMDBMoviesSearch(api: stubClient)
    
    let query = "dummy query"
    
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    let searchResource = MovieDBAPI.search(query: query).asTestResource
    let resolver = AsyncFakeAPIClientResultResolver(results: [
      searchResource: .success(stubResponse)
    ])
    stubClient.nextFetchResultResolver = resolver
    
    // when
    moviesSearch.search(query: query)
    moviesSearch.cancel()
    resolver.execute(for: searchResource)
    let state = moviesSearch.store.state
    
    // then
    XCTAssertTrue(state.status.isNotLoaded)
    XCTAssertEqual([], state.movies)
    XCTAssertEqual([], state.recentSearches)
    XCTAssertFalse(state.hasMore)
  }
  
  
}
