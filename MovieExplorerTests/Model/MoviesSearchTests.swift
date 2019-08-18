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
  
  func testInit_RecentSearches_LoadsRecentSearches() {
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
  
  func testSearch_Request_FetchesResource() {
    // given
    let query = "dummy query"
    let expectedResource = MovieDBAPI.search(query: query).asTestResource
    
    // when
    moviesSearch.search(query: query)
    let requestedResource = fakeAPIClient.lastResource
    
    // then
    XCTAssertEqual(expectedResource, requestedResource)
  }

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
    XCTAssertEqual(expectedRequestsCount, fakeAPIClient.requestsCount)
  }
  
  func testSearch_Response_SetsLoadedState() {
    // given
    let query = "dummy query"
    let stubResponse = make_singlepageResponse()
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
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
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
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
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
    // when
    moviesSearch.search(query: query)
    let state = moviesSearch.store.state
    
    // then
    XCTAssertFalse(state.hasMore)
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
  }
  
  func testSearch_Error_DoesNotUpdateRecentSearches() {
    // given
    let query = "dummy query"
    let error = APIError.unknown(inner: TestAPIError.anError)
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .failure(error))
    
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
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
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
    let firstSearchResource = MovieDBAPI.search(query: query).asTestResource
    fakeAPIClient.nextFetchResultResolver = SyncFakeAPIClientResultResolver(results: [
      firstSearchResource: .success(stubResponse)
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
  }
  
  func testSearch_FirstSearchFetchFinishesAfterSecondSearchStarted_DoesNotUpdateStateWithFirstFetchResults() {
    // given
    let query = "dummy query"
    let otherQuery = "other dummy query"
    
    let stubResponse = make_singlepageResponse()
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
    XCTAssertEqual([], state.recentSearches)
    XCTAssertFalse(state.hasMore)
  }
  
  
  // MARK: Search - recent searches tests
  
  func testSearch_Success_SavesRecentSearches() {
    // given
    let query = "dummy query"
    let stubResponse = make_singlepageResponse()
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
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
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
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
    let resourceFirstSearch = MovieDBAPI.search(query: query).asTestResource
    let resourceSecondSearch = MovieDBAPI.search(query: otherQuery).asTestResource
    fakeAPIClient.nextFetchResultResolver = SyncFakeAPIClientResultResolver(results: [
      resourceFirstSearch: .success(stubResponse),
      resourceSecondSearch: .success(stubResponse)
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
    XCTAssertEqual([], state.recentSearches)
  }
  
  func testSearch_QueryFromRecentSearches_MovesQueryToTop() {
    // given
    let query1 = "dummy query 1"
    let query2 = "dummy query 2"
    let query3 = "dummy query 3"
    
    let repeatingQuery = query2

    let stubResponse = make_singlepageResponse()
    let resourceSearch1 = MovieDBAPI.search(query: query1).asTestResource
    let resourceSearch2 = MovieDBAPI.search(query: query2).asTestResource
    let resourceSearch3 = MovieDBAPI.search(query: query3).asTestResource
    fakeAPIClient.nextFetchResultResolver = SyncFakeAPIClientResultResolver(results: [
      resourceSearch1: .success(stubResponse),
      resourceSearch2: .success(stubResponse),
      resourceSearch3: .success(stubResponse),
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
    let moviesSearch = TMDBMoviesSearch(api: fakeAPIClient,
                                        recentSearchesRepository: fakeRecentSearchesRepository,
                                        maxRecentSearchesCount: maxRecentSearches)
    
    let query1 = "dummy query 1"
    let query2 = "dummy query 2"
    let query3 = "dummy query 3"

    let stubResponse = make_singlepageResponse()
    let resourceSearch1 = MovieDBAPI.search(query: query1).asTestResource
    let resourceSearch2 = MovieDBAPI.search(query: query2).asTestResource
    let resourceSearch3 = MovieDBAPI.search(query: query3).asTestResource
    fakeAPIClient.nextFetchResultResolver = SyncFakeAPIClientResultResolver(results: [
      resourceSearch1: .success(stubResponse),
      resourceSearch2: .success(stubResponse),
      resourceSearch3: .success(stubResponse),
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
    
    let firstPageResource = MovieDBAPI.search(query: query).asTestResource
    let secondPageResource = MovieDBAPI.search(query: query, page: 2).asTestResource
    let stubResponse = make_singlepageResponse()
    let stubResponseSecondCall = make_multipageResponseFirstPage()
    
    fakeAPIClient.nextFetchResultResolver = SyncFakeAPIClientResultResolver(results: [
      firstPageResource: .success(stubResponse),
      secondPageResource: .success(stubResponseSecondCall),
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
    
    let resourceFirstPage = MovieDBAPI.search(query: query).asTestResource
    let resourceSecondPage = MovieDBAPI.search(query: query, page: 2).asTestResource
    let stubResponseFirstPage = make_multipageResponseFirstPage()
    let stubResponseSecondPage = make_multipageResponseSecondPage()
    
    fakeAPIClient.nextFetchResultResolver = SyncFakeAPIClientResultResolver(results: [
      resourceFirstPage: .success(stubResponseFirstPage),
      resourceSecondPage: .success(stubResponseSecondPage),
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
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))

    let expectedResource = MovieDBAPI.search(query: query, page: 2).asTestResource
    
    // when
    moviesSearch.search(query: query)
    moviesSearch.loadNext()
    let requestedResource = fakeAPIClient.lastResource!

    // then
    XCTAssertEqual(expectedResource, requestedResource)
  }
  
  func testLoadNext_WhileSearchNotFinished_DoesNotPerformSecondFetch() {
    // given
    let query = "dummy query"
    let stubResponse = make_singlepageResponse()
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
    
    let stubResponse = make_singlepageResponse()
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

  func testCancel_AfterSuccessfulSearch_KeepsRecentSearches() {
    // given
    let query = "dummy query"
    
    let stubResponse = make_singlepageResponse()
    fakeAPIClient.nextFetchResultResolver = SingleSyncFakeAPIClientResultResolver(result: .success(stubResponse))
    
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
