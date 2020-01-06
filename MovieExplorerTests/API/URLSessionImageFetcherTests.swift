//
//  URLSessionImageFetcherTests.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 21.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import XCTest
@testable import MovieExplorer

private let testServerConfig = MovieDBServerConfig(
  apiBase: URL(string: "http://api.example.com")!,
  imageBase: URL(string: "http://image.example.com")!,
  apiKey: "a test api key"
)

class URLSessionImageFetcherTests: XCTestCase {
  
  private var cache = ImageCache()
  private var sessionMock = FakeURLSession()
  private lazy var fetcher = URLSessionImageFetcher(
    serverConfig: testServerConfig, urlSession: sessionMock, cache: cache
  )

  override func setUp() {
    super.setUp()
    sessionMock = FakeURLSession()
    cache = ImageCache()
    fetcher = URLSessionImageFetcher(serverConfig: testServerConfig, urlSession: sessionMock, cache: cache)
  }

  func testPosterURL_Get_ReturnsCorrectURL() {
    // given
    let expectedPosterURL = URL(string: "http://image.example.com/w780/42")!

    // when
    let posterURL = fetcher.posterURL(path: "42", size: .w780)
    
    // then
    XCTAssertEqual(expectedPosterURL, posterURL)
  }
  
}
