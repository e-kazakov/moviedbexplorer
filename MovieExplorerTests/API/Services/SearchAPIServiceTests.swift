//
//  SearchAPIServiceTests.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 01.10.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import XCTest
@testable import MovieExplorer

private let searchEndpointPath = "3/search/movie"
private let searchQueryQueryParameter = "query"
private let pageQueryParameter = "page"

class SearchAPIServiceTests: XCTestCase {
    
  private var service: SearchAPIServiceImpl!
  private var fakeAPIClient: FakeAPIClient!
  
  override func setUp() {
    super.setUp()
    
    fakeAPIClient = FakeAPIClient()
    service = SearchAPIServiceImpl(client: fakeAPIClient)
  }
  
  override func tearDown() {
    super.tearDown()
    
    service = nil
    fakeAPIClient = nil
  }
  
  func testSearch_FetchesURLRequestWithCorrectPath() {
    // given
    let query = "search query"
    
    // when
    service.search(query: query, page: nil) { _ in }
    
    // then
    XCTAssertEqual(1, fakeAPIClient.fetchInvocations.count)
    let actualPath = fakeAPIClient.fetchInvocations[0].url?.path
    XCTAssertEqual(searchEndpointPath, actualPath)
  }
  
  func testSearch_InitialPage_URLRequestWithSearchQueryQueryParameter() {
    // given
    let page: Int? = nil
    let query = "search query"
    
    // when
    service.search(query: query, page: page) { _ in }

    // then
    let requestedURL = fakeAPIClient.fetchInvocations[0].url!
    let actualQuery = requestedURL.queryParameter(searchQueryQueryParameter)
    XCTAssertEqual(query, actualQuery)
  }
  
  func testSearch_InitialPage_URLRequestWithoutPageQueryParameter() {
    // given
    let page: Int? = nil
    let query = "search query"
    
    // when
    service.search(query: query, page: page) { _ in }

    // then
    let requestedURL = fakeAPIClient.fetchInvocations[0].url!
    XCTAssertNil(requestedURL.queryParameter(pageQueryParameter))
  }

  func testDiscover_SecondPage_URLRequestWithPageQueryParameter() {
    // given
    let page = 2
    let expectedPageQueryParameter = "2"
    let query = "search query"
    
    // when
    service.search(query: query, page: page) { _ in }

    // then
    let requestedURL = fakeAPIClient.fetchInvocations[0].url!
    let actualPageQueryParameter = requestedURL.queryParameter(pageQueryParameter)
    XCTAssertEqual(expectedPageQueryParameter, actualPageQueryParameter)
  }
}
