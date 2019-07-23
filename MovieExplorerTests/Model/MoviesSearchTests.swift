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
  
  private var moviesSearch: TMDBMoviesSearch!
  private var fakeAPIClient: FakeAPIClient!
  private var fakeRecentSearchesRepository: FakeRecentSearchesRepository!
  
  override func setUp() {
    super.setUp()
    
    fakeAPIClient = FakeAPIClient()
    fakeRecentSearchesRepository = FakeRecentSearchesRepository()
    moviesSearch = TMDBMoviesSearch(api: fakeAPIClient, recentSearchesRepository: fakeRecentSearchesRepository)
  }
  
  override func tearDown() {
    fakeAPIClient = nil
    moviesSearch = nil
    
    super.tearDown()
  }
  
  // MARK: Init tests
  
  func testInit_NotLoadedState() {
    // given
    let stubClient = FakeAPIClient()
    let fakeRecentSearchesRepository = FakeRecentSearchesRepository()
    
    // when
    let moviesSearch = TMDBMoviesSearch(api: stubClient, recentSearchesRepository: fakeRecentSearchesRepository)
    let state = moviesSearch.store.state

    // then
    XCTAssertTrue(state.status.isNotLoaded)
    XCTAssertEqual([], state.movies)
    XCTAssertEqual([], state.recentSearches)
    XCTAssertFalse(state.hasMore)
  }
  
  func testInit_RecentSearches_() {
    //given
    let expectedRecentSearches = ["Matrix", "Die hard"]
    
    let stubClient = FakeAPIClient()
    let fakeRecentSearchesRepository = FakeRecentSearchesRepository()
    fakeRecentSearchesRepository.searches = expectedRecentSearches

    //when
    let moviesSearch = TMDBMoviesSearch(api: stubClient, recentSearchesRepository: fakeRecentSearchesRepository)
    let state = moviesSearch.store.state
    
    //then
    XCTAssertEqual(expectedRecentSearches, state.recentSearches)
  }
  
  // MARK: Search tests
  
  func testSearch_Request_SetsLoadingState() {
    // given
    let query = "dummy query"
    
    // when
    moviesSearch.search(query: query)
    let state = moviesSearch.store.state
    
    // then
    XCTAssertTrue(state.status.isLoading)
  }
  
  func testSearch_SecondCallSameQuery_DoesNothing() {
    // given
    let query = "dummy query"
    let expectedRequestsCount = 1
    
    // when
    moviesSearch.search(query: query)
    moviesSearch.search(query: query)
    
    // then
    XCTAssertEqual(expectedRequestsCount, fakeAPIClient.requestsCount)
  }
  
  func testSearch_SinglePage_UpdatesStateWithResponse() {
    // given
    let query = "dummy query"
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
    // when
    moviesSearch.search(query: query)
    let state = moviesSearch.store.state
    
    // then
    XCTAssertFalse(state.hasMore)
    XCTAssertTrue(state.status.isLoaded)
    XCTAssertEqual(stubResponse.results, state.movies)
  }
  
  func testSearch_Success_SavesRecentSearches() {
    // given
    let query = "dummy query"
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
    // when
    moviesSearch.search(query: query)
    
    // then
    XCTAssertEqual([query], fakeRecentSearchesRepository.searches)
  }
  
  func testSearch_Error_UpdatesStateWithError() {
    // given
    let query = "dummy query"
    let error = APIError.unknown(inner: TestAPIError.anError)
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .failure(error))

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
    let query = "dummy query"
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 2
    )
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
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
    let query = "dummy query"
    let otherQuery = "other dummy query"
    
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    let firstSearchResource = MovieDBAPI.search(query: query).asTestResource
    fakeAPIClient.nextFetchResultResolver = SyncFakeAPIClientResultResolver(results: [
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
    fakeAPIClient.nextFetchResultResolver = SyncFakeAPIClientResultResolver(results: [
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
    fakeAPIClient.nextFetchResultResolver = resolver

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
    let query = "dummy query"
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))

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
    let query = "dummy query"
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 2,
      totalPages: 2
    )
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))

    let expectedResource = MovieDBAPI.search(query: query, page: 2).asTestResource
    
    // when
    moviesSearch.search(query: query)
    moviesSearch.loadNext()
    let requestedResource = fakeAPIClient.lastResource!

    // then
    XCTAssertEqual(expectedResource, requestedResource)
  }
  
  func testLoadNext_SecondLoadWhileFirstNotFinished_DoesNothing() {
    // given
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
    fakeAPIClient.nextFetchResultResolver = resolver
    
    let expectedRequestsCount = 1

    // when
    moviesSearch.search(query: query)
    moviesSearch.loadNext()
    
    // then
    XCTAssertEqual(expectedRequestsCount, fakeAPIClient.requestsCount)
  }
  
  // MARK: Cancel tests
  
  func testCancel_AfterSuccessfulSearch_ResetsState() {
    // given
    let query = "dummy query"
    
    let stubResponse = APIPaginatedRes<Movie>(
      page: 1,
      results: [Movie.random],
      totalResults: 1,
      totalPages: 1
    )
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
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
    fakeAPIClient.nextFetchResultResolver = resolver
    
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
