//
//  URLSessionAPIClientTests.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 9/9/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import XCTest
@testable import MovieExplorer

private let testServerConfig = MovieDBServerConfig(
  apiBase: URL(string: "http://api.example.com")!,
  imageBase: URL(string: "http://image.example.com")!,
  apiKey: "a test api key"
)
private let apiKeyQueryParameter = "api_key"
private let apiKeyQueryItem = URLQueryItem(name: apiKeyQueryParameter,
                                           value: testServerConfig.apiKey)

class URLSessionAPIClientTests: XCTestCase {
  
  private var sessionMock = FakeURLSession()
  private lazy var client = URLSessionAPIClient(serverConfig: testServerConfig, urlSession: sessionMock)
  
  override func setUp() {
    super.setUp()
    sessionMock = FakeURLSession()
    client = URLSessionAPIClient(serverConfig: testServerConfig, urlSession: sessionMock)
  }
  
  func testFetch_Request_AppendsPathToApiBase() {
    // given
    let path = "/v3/url"
    let req = URLRequest(path: path)
    var expectedResult = URLRequest(url: testServerConfig.apiBase.appendingPathComponent(path))
    expectedResult.appendQueryItem(apiKeyQueryItem)
    
    // when
    client.fetch(request: req) { _ in }
    let actualResult = sessionMock.dataTaskInvocations.last!

    // then
    XCTAssertEqual(expectedResult, actualResult)
  }
  
  func testFetch_Request_ReturnsResumedDataTask() {
    // given
    let req = URLRequest(path: "/v3/url")
    let dataTask = FakeURLSessionDataTask()
    sessionMock.nextDataTask = dataTask
    
    // when
    client.fetch(request: req) { _ in }
    
    // then
    XCTAssertTrue(dataTask.isResumed, "Data task should be resumed.")
  }
  
  func testFetch_Dispose_CancelsDataTask() {
    // given
    let req = URLRequest(path: "/v3/url")
    let dataTask = FakeURLSessionDataTask()
    sessionMock.nextDataTask = dataTask

    // when
    var disposable = client.fetch(request: req) { _ in }
    disposable.dispose()

    // then
    XCTAssertTrue(dataTask.isCancelled)
  }
  
  func testFetch_Dispose_CallbackNotCalled() {
    // given
    let path = "/v3/url"
    let req = URLRequest(path: path)
    var fullReq = URLRequest(url: testServerConfig.apiBase.appendingPathComponent(path))
    fullReq.appendQueryItem(apiKeyQueryItem)
    
    let dataTask = FakeURLSessionDataTask()
    sessionMock.nextDataTask = dataTask
    let resolver = AsyncResolver<FakeURLSession.DataTaskParameters, FakeURLSession.DataTaskResult>(results: [
      fullReq: .empty
    ])
    sessionMock.dataTaskResolver = resolver
    
    // when
    var disposable = client.fetch(request: req) { _ in
      XCTFail("Callback should not be called for disposed fetch request")
    }
    disposable.dispose()
    resolver.executeAll()

    // then
    XCTAssertTrue(dataTask.isCancelled)
  }

  func testFetch_Resource_AppendsApiKeyQueryItem() {
    // given
    let req = URLRequest(path: "/v3/url")
    let apiKeyQueryItem = URLQueryItem(name: URLSessionAPIClient.apiKeyQueryItemName, value: testServerConfig.apiKey)

    // when
    client.fetch(request: req) { _ in }

    // then
    let lastDataTaskRequest = sessionMock.dataTaskInvocations.last
    XCTAssertNotNil(lastDataTaskRequest)

    let components = URLComponents(url: lastDataTaskRequest!.url!,
                                   resolvingAgainstBaseURL: false)!
    let queryItems = components.queryItems ?? []
    XCTAssertTrue(
      queryItems.contains(apiKeyQueryItem),
      "Query part of the request URL should contain api key."
    )
  }

  func testFetch_ResourceWithResponseData_ParsesReturnedData() {
    // given
    let req = URLRequest(path: "/v3/url")
    let movie = TestAPIMovie(name: "Avengers")
    let jsonString = "{ \"name\": \"Avengers\" }"
    let jsonData = jsonString.data(using: .utf8)!

    sessionMock.dataTaskResolver = SingleSyncResolver(result: .init(data: jsonData))

    // when
    var result: Result<TestAPIMovie, APIError>?
    let exp = expectation(description: "fetch")
    client.fetch(request: req) { (response: Result<TestAPIMovie, APIError>) in
      result = response
      exp.fulfill()
    }

    // then
    waitForExpectations(timeout: 1.0)
    XCTAssertTrue(result!.isSuccess)
    XCTAssertEqual(movie, result?.tryGetValue())
  }

  func testFetch_DataTaskError_ReturnsFailureWithNetworkError() {
    // given
    let req = URLRequest(path: "/v3/url")
    let requestError = TestAPIError.anError
    sessionMock.dataTaskResolver = SingleSyncResolver(result: .init(error: requestError))

    // when
    var result: Result<TestAPIMovie, APIError>?
    let exp = expectation(description: "fetch")
    client.fetch(request: req) { (response: Result<TestAPIMovie, APIError>) in
      result = response
      exp.fulfill()
    }

    // then
    waitForExpectations(timeout: 1.0)

    XCTAssertTrue(result!.isFailure)
    let error = result!.tryGetError()!
    XCTAssertTrue(error.isNetworkError)
    let innerError = error.networkInnerError! as? TestAPIError
    XCTAssertEqual(requestError, innerError)
  }

  func testFetch_ParsingError_ReturnsFailureWithMappingError() {
    // given
    let req = URLRequest(path: "/v3/url")
    let nonJSONData = Data()
    sessionMock.dataTaskResolver = SingleSyncResolver(result: .init(data: nonJSONData))

    // when
    var result: Result<TestAPIMovie, APIError>?
    let exp = expectation(description: "fetch")
    client.fetch(request: req) { (response: Result<TestAPIMovie, APIError>) in
      result = response
      exp.fulfill()
    }

    // then
    waitForExpectations(timeout: 1.0)
    XCTAssertTrue(result!.isFailure)
    let error = result!.tryGetError()!
    XCTAssertTrue(error.isJSONMappingError)
    let innerError = error.jsonMappingInnerError!
    XCTAssertTrue(innerError.isJSONDecondingError)
  }

  func testFetch_JSONMappingNoData_ReturnsFailureWithNoDataError() {
    // given
    let req = URLRequest(path: "/v3/url")
    sessionMock.dataTaskResolver = SingleSyncResolver(result: .empty)

    // when
    var result: Result<TestAPIMovie, APIError>?
    let exp = expectation(description: "fetch")
    client.fetch(request: req) { (response: Result<TestAPIMovie, APIError>) in
      result = response
      exp.fulfill()
    }

    // then
    waitForExpectations(timeout: 1.0)
    XCTAssertTrue(result!.isFailure)
    let error = result!.tryGetError()!
    XCTAssertTrue(error.isJSONMappingError)
    let innerError = error.jsonMappingInnerError!
    XCTAssertTrue(innerError.isNoDataError)
  }
}

private struct TestAPIMovie: Codable, Equatable {
  let name: String
}
