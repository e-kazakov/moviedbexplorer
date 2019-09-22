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
  private var fakeAPIService: FakeSearchAPIService!
  private var fakeRecentSearchesRepository: FakeRecentSearchesRepository!
  
  override func setUp() {
    super.setUp()
    
    fakeAPIService = FakeSearchAPIService()
    fakeRecentSearchesRepository = FakeRecentSearchesRepository()
    moviesSearch = TMDBMoviesSearch(service: fakeAPIService,
                                    recentSearchesRepository: fakeRecentSearchesRepository)
  }
  
  override func tearDown() {
    fakeAPIService = nil
    moviesSearch = nil
    
    super.tearDown()
  }
  
  // MARK: Init tests
  
  func testInit_NotLoadedState() {
    // given
    let stubAPIService = FakeSearchAPIService()
    let fakeRecentSearchesRepository = FakeRecentSearchesRepository()
    
    // when
    let moviesSearch = TMDBMoviesSearch(service: stubAPIService, recentSearchesRepository: fakeRecentSearchesRepository)
    let state = moviesSearch.store.state

    // then
    XCTAssertTrue(state.status.isNotLoaded)
    XCTAssertEqual([], state.movies)
    XCTAssertEqual([], state.recentSearches)
    XCTAssertFalse(state.hasMore)
  }
  
  func testInit_RecentSearches_LoadsRecentSearches() {
    //given
    let expectedRecentSearches = ["Matrix", "Die hard"]
    
    let stubAPIService = FakeSearchAPIService()
    let fakeRecentSearchesRepository = FakeRecentSearchesRepository()
    fakeRecentSearchesRepository.searches = expectedRecentSearches

    //when
    let moviesSearch = TMDBMoviesSearch(service: stubAPIService, recentSearchesRepository: fakeRecentSearchesRepository)
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

  func testSearch_SecondSearchSameQuery_NoSecondRequest() {
    // given
    let query = "dummy query"
    let expectedRequestsCount = 1

    // when
    moviesSearch.search(query: query)
    moviesSearch.search(query: query)

    // then
    XCTAssertEqual(expectedRequestsCount, fakeAPIService.searchInvocations.count)
  }

  func testSearch_Response_SetsLoadedState() {
    // given
    let query = "dummy query"
    let stubResponse = make_singlepageResponse()
    fakeAPIService.searchResolver = SingleSyncResolver(result: .success(stubResponse))

    // when
    moviesSearch.search(query: query)
    let state = moviesSearch.store.state

    // then
    XCTAssertTrue(state.status.isLoaded)
  }

  func testSearch_Response_UpdatesMovies() {
    // given
    let query = "dummy query"
    let stubResponse = make_singlepageResponse()
    fakeAPIService.searchResolver = SingleSyncResolver(result: .success(stubResponse))

    // when
    moviesSearch.search(query: query)
    let state = moviesSearch.store.state

    // then
    XCTAssertTrue(state.status.isLoaded)
  }

  func testSearch_SinglePage_HasMoreReturnsFalse() {
    // given
    let query = "dummy query"
    let stubResponse = make_singlepageResponse()
    fakeAPIService.searchResolver = SingleSyncResolver(result: .success(stubResponse))

    // when
    moviesSearch.search(query: query)
    let state = moviesSearch.store.state

    // then
    XCTAssertFalse(state.hasMore)
  }

  func testSearch_Error_UpdatesStateWithError() {
    // given
    let query = "dummy query"
    fakeAPIService.searchResolver = SingleSyncResolver(result: .failure(.invalidResponse))

    // when
    moviesSearch.search(query: query)
    let state = moviesSearch.store.state

    // then
    XCTAssertTrue(state.status.isError)
  }

  func testSearch_Error_DoesNotUpdateRecentSearches() {
    // given
    let query = "dummy query"
    fakeAPIService.searchResolver = SingleSyncResolver(result: .failure(.invalidResponse))

    // when
    moviesSearch.search(query: query)
    let state = moviesSearch.store.state

    // then
    XCTAssertEqual([], state.recentSearches)
  }

  func testSearch_MultipageResponse_HasMoreReturnsTrue() {
    // given
    let query = "dummy query"
    let stubResponse = make_multipageResponseFirstPage()
    fakeAPIService.searchResolver = SingleSyncResolver(result: .success(stubResponse))

    // when
    moviesSearch.search(query: query)
    let state = moviesSearch.store.state

    // then
    XCTAssertTrue(state.hasMore)
  }

  func testSearch_SecondSearchDifferentQueryRequest_ClearsPreviousSearchResult() {
    // given
    let query = "dummy query"
    let otherQuery = "other dummy query"

    let stubResponse = make_singlepageResponse()
    fakeAPIService.searchResolver = SyncResolver(results: [
      .init(query: query, page: nil): .success(stubResponse)
    ])

    // when
    moviesSearch.search(query: query)
    moviesSearch.search(query: otherQuery)
    let state = moviesSearch.store.state

    // then
    XCTAssertEqual([], state.movies)
  }

  func testSearch_FirstSearchFetchFinishesAfterSecondSearchStarted_IsLoadingState() {
    // given
    let query = "dummy query"
    let otherQuery = "other dummy query"
    
    let stubResponse = make_singlepageResponse()
    let resolver = AsyncResolver<FakeSearchAPIService.SearchParameters, FakeSearchAPIService.SearchResult>(results: [
      .init(query: query, page: nil): .success(stubResponse)
    ])
    fakeAPIService.searchResolver = resolver
    
    // when
    moviesSearch.search(query: query)
    moviesSearch.search(query: otherQuery)
    resolver.execute(for: .init(query: query, page: nil))
    let state = moviesSearch.store.state

    // then
    XCTAssertTrue(state.status.isLoading)
  }

  func testSearch_FirstSearchFetchFinishesAfterSecondSearchStarted_DoesNotUpdateStateWithFirstFetchResults() {
    // given
    let query = "dummy query"
    let otherQuery = "other dummy query"

    let stubResponse = make_singlepageResponse()
    let resolver = AsyncResolver<FakeSearchAPIService.SearchParameters, FakeSearchAPIService.SearchResult>(results: [
      .init(query: query, page: nil): .success(stubResponse)
    ])
    fakeAPIService.searchResolver = resolver

    // when
    moviesSearch.search(query: query)
    moviesSearch.search(query: otherQuery)
    resolver.execute(for: .init(query: query, page: nil))
    let state = moviesSearch.store.state

    // then
    XCTAssertEqual([], state.recentSearches)
    XCTAssertFalse(state.hasMore)
  }


  // MARK: Search - recent searches tests

  func testSearch_Success_SavesRecentSearches() {
    // given
    let query = "dummy query"
    let stubResponse = make_singlepageResponse()
    fakeAPIService.searchResolver = SingleSyncResolver(result: .success(stubResponse))

    let expectedRecentSearches = [query]

    // when
    moviesSearch.search(query: query)

    // then
    XCTAssertEqual(expectedRecentSearches, fakeRecentSearchesRepository.searches)
  }

  func testSearch_Success_UpdatesRecentSearches() {
    // given
    let query = "dummy query"
    let stubResponse = make_singlepageResponse()
    fakeAPIService.searchResolver = SingleSyncResolver(result: .success(stubResponse))

    let expectedRecentSearches = [query]

    // when
    moviesSearch.search(query: query)
    let state = moviesSearch.store.state

    // then
    XCTAssertEqual(expectedRecentSearches, state.recentSearches)
  }

  func testSearch_SecondSearchDifferentQueryReponse_UpdatesRecentSearches() {
    // given
    let query = "dummy query"
    let otherQuery = "other dummy query"

    let stubResponse = make_singlepageResponse()
    fakeAPIService.searchResolver = SyncResolver(results: [
      .init(query: query, page: nil): .success(stubResponse),
      .init(query: otherQuery, page: nil): .success(stubResponse)
    ])

    let expectedRecentSearches = [otherQuery, query]

    // when
    moviesSearch.search(query: query)
    moviesSearch.search(query: otherQuery)
    let state = moviesSearch.store.state

    // then
    XCTAssertEqual(expectedRecentSearches, state.recentSearches)
  }

  func testSearch_FirstSearchFetchFinishesAfterSecondSearchStarted_DoesNotUpdateRecentSearches() {
    // given
    let query = "dummy query"
    let otherQuery = "other dummy query"

    let stubResponse = make_singlepageResponse()
    let resolver = AsyncResolver<FakeSearchAPIService.SearchParameters, FakeSearchAPIService.SearchResult>(results: [
      .init(query: query, page: nil): .success(stubResponse)
    ])

    // when
    moviesSearch.search(query: query)
    moviesSearch.search(query: otherQuery)
    resolver.execute(for: .init(query: query, page: nil))
    let state = moviesSearch.store.state

    // then
    XCTAssertEqual([], state.recentSearches)
  }

  func testSearch_QueryFromRecentSearches_MovesQueryToTop() {
    // given
    let query1 = "dummy query 1"
    let query2 = "dummy query 2"
    let query3 = "dummy query 3"

    let repeatingQuery = query2

    let stubResponse = make_singlepageResponse()
    fakeAPIService.searchResolver = SyncResolver(results: [
      .init(query: query1, page: nil): .success(stubResponse),
      .init(query: query2, page: nil): .success(stubResponse),
      .init(query: query3, page: nil): .success(stubResponse),
    ])

    let expectedRecentSearches = [query2, query3, query1]

    // when
    moviesSearch.search(query: query1)
    moviesSearch.search(query: query2)
    moviesSearch.search(query: query3)
    moviesSearch.search(query: repeatingQuery)
    let state = moviesSearch.store.state

    // then
    XCTAssertEqual(expectedRecentSearches, state.recentSearches)
  }

  func testSearch_RecentSearchesOverLimit_DropsEarliestQuery() {
    // given
    let maxRecentSearches = 2
    let moviesSearch = TMDBMoviesSearch(service: fakeAPIService,
                                        recentSearchesRepository: fakeRecentSearchesRepository,
                                        maxRecentSearchesCount: maxRecentSearches)

    let query1 = "dummy query 1"
    let query2 = "dummy query 2"
    let query3 = "dummy query 3"

    let stubResponse = make_singlepageResponse()
    fakeAPIService.searchResolver = SyncResolver(results: [
      .init(query: query1, page: nil): .success(stubResponse),
      .init(query: query2, page: nil): .success(stubResponse),
      .init(query: query3, page: nil): .success(stubResponse),
    ])

    let expectedRecentSearches = [query3, query2]

    // when
    moviesSearch.search(query: query1)
    moviesSearch.search(query: query2)
    moviesSearch.search(query: query3)
    let state = moviesSearch.store.state

    // then
    XCTAssertEqual(expectedRecentSearches, state.recentSearches)
  }

  // MARK: LoadNext tests

  func testLoadNext_SinglePage_NoSecondFetch() {
    // given
    let query = "dummy query"

    let stubResponse = make_singlepageResponse()
    let stubResponseSecondCall = make_multipageResponseFirstPage()

    fakeAPIService.searchResolver = SyncResolver(results: [
      .init(query: query, page: nil): .success(stubResponse),
      .init(query: query, page: 2): .success(stubResponseSecondCall),
    ])

    let expectedMovies = stubResponse.results

    // when
    moviesSearch.search(query: query)
    moviesSearch.loadNext()
    let state = moviesSearch.store.state

    // then
    XCTAssertEqual(expectedMovies, state.movies)
  }

  func testLoadNext_Multipage_AppendsMovies() {
    // given
    let query = "dummy query"

    let stubResponseFirstPage = make_multipageResponseFirstPage()
    let stubResponseSecondPage = make_multipageResponseSecondPage()

    fakeAPIService.searchResolver = SyncResolver(results: [
      .init(query: query, page: nil): .success(stubResponseFirstPage),
      .init(query: query, page: 2): .success(stubResponseSecondPage),
    ])

    let expectedMovies = stubResponseFirstPage.results + stubResponseSecondPage.results

    // when
    moviesSearch.search(query: query)
    moviesSearch.loadNext()
    let state = moviesSearch.store.state

    // then
    XCTAssertEqual(expectedMovies, state.movies)
  }

  func testLoadNext_MultiPage_RequestsCorrectPage() {
    // given
    let query = "dummy query"
    let stubResponse = make_multipageResponseFirstPage()
    fakeAPIService.searchResolver = SingleSyncResolver(result: .success(stubResponse))

    let expectedParameters = FakeSearchAPIService.SearchParameters(query: query, page: 2)

    // when
    moviesSearch.search(query: query)
    moviesSearch.loadNext()
    let requestedParameters = fakeAPIService.searchInvocations.last!

    // then
    XCTAssertEqual(expectedParameters, requestedParameters)
  }

  func testLoadNext_WhileSearchNotFinished_DoesNotPerformSecondFetch() {
    // given
    let query = "dummy query"

    let expectedRequestsCount = 1

    // when
    moviesSearch.search(query: query)
    moviesSearch.loadNext()

    // then
    XCTAssertEqual(expectedRequestsCount, fakeAPIService.searchInvocations.count)
  }

  // MARK: Cancel tests

  func testCancel_AfterSuccessfulSearch_ResetsState() {
    // given
    let query = "dummy query"

    let stubResponse = make_singlepageResponse()
    fakeAPIService.searchResolver = SingleSyncResolver(result: .success(stubResponse))

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

  func testCancel_AfterSuccessfulSearch_KeepsRecentSearches() {
    // given
    let query = "dummy query"

    let stubResponse = make_singlepageResponse()
    fakeAPIService.searchResolver = SingleSyncResolver(result: .success(stubResponse))

    let expectedRecentSearches = [query]

    // when
    moviesSearch.search(query: query)
    moviesSearch.cancel()
    let state = moviesSearch.store.state

    // then
    XCTAssertEqual(expectedRecentSearches, state.recentSearches)
  }

  func testCancel_FetchCompletesAfter_DoesNotUpdateStateWithResults() {
    // given
    let query = "dummy query"

    let stubResponse = make_singlepageResponse()
    let resolver = AsyncResolver<FakeSearchAPIService.SearchParameters, FakeSearchAPIService.SearchResult>(results: [
      .init(query: query, page: 1): .success(stubResponse)
    ])
    
    // when
    moviesSearch.search(query: query)
    moviesSearch.cancel()
    resolver.execute(for: .init(query: query, page: 1))
    let state = moviesSearch.store.state

    // then
    XCTAssertTrue(state.status.isNotLoaded)
    XCTAssertEqual([], state.movies)
    XCTAssertEqual([], state.recentSearches)
  }
  
}

// MARK: - Factories

private func make_singlepageResponse() -> APIPaginatedResponse<Movie> {
  return APIPaginatedResponse<Movie>(
    page: 1,
    results: [Movie.random],
    totalResults: 1,
    totalPages: 1
  )
}

private func make_multipageResponseFirstPage() -> APIPaginatedResponse<Movie> {
  return APIPaginatedResponse<Movie>(
    page: 1,
    results: [Movie.random],
    totalResults: 2,
    totalPages: 2
  )
}

private func make_multipageResponseSecondPage() -> APIPaginatedResponse<Movie> {
  return APIPaginatedResponse<Movie>(
    page: 2,
    results: [Movie.random],
    totalResults: 2,
    totalPages: 2
  )
}
