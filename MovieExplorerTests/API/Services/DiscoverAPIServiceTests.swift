//
//  DiscoverAPIServiceTests.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 01.10.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import XCTest
@testable import MovieExplorer

private let discoverEndpointPath = "3/discover/movie"
private let pageQueryParameter = "page"

class DiscoverAPIServiceTests: XCTestCase {
  
  private var service: DiscoverAPIServiceImpl!
  private var fakeAPIClient: FakeAPIClient!
  
  override func setUp() {
    super.setUp()
    
    fakeAPIClient = FakeAPIClient()
    service = DiscoverAPIServiceImpl(client: fakeAPIClient)
  }
  
  override func tearDown() {
    super.tearDown()
    
    service = nil
    fakeAPIClient = nil
  }
  
  func testDiscover_FetchesURLRequestWithCorrectPath() {
    // given
    
    // when
    service.discover(page: nil) { _ in }
    
    // then
    XCTAssertEqual(1, fakeAPIClient.fetchInvocations.count)
    let actualPath = fakeAPIClient.fetchInvocations[0].url?.path
    XCTAssertEqual(discoverEndpointPath, actualPath)
  }
  
  func testDiscover_InitialPage_URLRequestWithoutPageQueryParameter() {
    // given
    let page: Int? = nil
    
    // when
    service.discover(page: page) { _ in }
    
    // then
    let requestedURL = fakeAPIClient.fetchInvocations[0].url!
    XCTAssertNil(requestedURL.queryParameter(pageQueryParameter))
  }

  func testDiscover_SecondPage_URLRequestWithPageQueryParameter() {
    // given
    let page = 2
    let expectedPageQueryParameter = "2"
    
    // when
    service.discover(page: page) { _ in }
    
    // then
    let requestedURL = fakeAPIClient.fetchInvocations[0].url!
    let actualPageQueryParameter = requestedURL.queryParameter(pageQueryParameter)
    XCTAssertEqual(expectedPageQueryParameter, actualPageQueryParameter)
  }
}
