//
//  URLSessionAPIClientTests.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 9/9/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import XCTest
@testable import MovieExplorer

let testServerConfig = MovieDBServerConfig(
  apiBase: URL(string: "http://api.example.com")!,
  imageBase: URL(string: "http://image.example.com")!,
  apiKey: "a test api key"
)

class URLSessionAPIClientTests: XCTestCase {
  
  private var sessionMock = FakeURLSession()
  private lazy var client = URLSessionAPIClient(serverConfig: testServerConfig, urlSession: sessionMock)
  
  override func setUp() {
    super.setUp()
    sessionMock = FakeURLSession()
    client = URLSessionAPIClient(serverConfig: testServerConfig, urlSession: sessionMock)
  }
  
  func testPosterURL_Get_ReturnsCorrectURL() {
    // given
    let expectedPosterURL = URL(string: "http://image.example.com/w780/42")!

    // when
    let posterURL = client.posterURL(path: "42", size: .w780)
    
    // then
    XCTAssertEqual(expectedPosterURL, posterURL)
  }
  
  func testFetch_Resource_ConstructsRequestWithCorrectHTTPMethod() {
    // given
    let resource = TestAPI.find()
    
    // when
    client.fetch(resource: resource) { _ in }
    
    // then
    XCTAssertNotNil(sessionMock.lastRequest)
    XCTAssertEqual(resource.method.rawValue, sessionMock.lastRequest!.httpMethod)
  }
  
  func testFetch_Resource_ResumesTheDataTask() {
    // given
    let dataTask = FakeURLSessionDataTask()
    sessionMock.nextDataTask = dataTask
    
    // when
    client.fetch(resource: TestAPI.movie()) { _ in }
    
    // then
    XCTAssertTrue(dataTask.isResumed, "Data task should be resumed.")
  }
  
  func testFetch_Dispose_CancelsDataTask() {
    // given
    let dataTask = FakeURLSessionDataTask()
    sessionMock.nextDataTask = dataTask

    // when
    var disposable = client.fetch(resource: TestAPI.movie()) { _ in }
    disposable.dispose()

    // then
    XCTAssertTrue(dataTask.isCancelled)
  }
  
  func testFetch_Resource_AppendsApiKeyQueryItem() {
    // given
    let apiKeyQueryItem = URLQueryItem(name: URLSessionAPIClient.apiKeyQueryItemName, value: testServerConfig.apiKey)

    // when
    client.fetch(resource: TestAPI.movie()) { _ in }
    
    // then
    XCTAssertNotNil(sessionMock.lastRequest)
    
    let components = URLComponents(url: sessionMock.lastRequest!.url!,
                                   resolvingAgainstBaseURL: false)!
    let queryItems = components.queryItems ?? []
    XCTAssertTrue(
      queryItems.contains(apiKeyQueryItem),
      "Query part of the request URL should contain api key."
    )
  }
  
  func testFetch_ResourceWithResponseData_ParsesReturnedData() {
    // given
    let movie = TestAPIMovie(name: "Avengers")
    let jsonString = "{ \"name\": \"Avengers\" }"
    let jsonData = jsonString.data(using: .utf8)!
    
    sessionMock.nextResponse = FakeResponse(data: jsonData)
    
    // when
    var result: Result<TestAPIMovie, APIError>?
    let exp = expectation(description: "fetch")
    client.fetch(resource: TestAPI.movie()) { response in
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
    let requestError = TestAPIError.anError
    sessionMock.nextResponse = FakeResponse(error: requestError)

    // when
    var result: Result<TestAPIMovie, APIError>?
    let exp = expectation(description: "fetch")
    client.fetch(resource: TestAPI.movie()) { response in
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
    sessionMock.nextResponse = FakeResponse(data: Data())
    let parsingInnerError = TestAPIError.anError
    let parsingError = ParsingError.jsonDecoding(inner: parsingInnerError)
    
    // when
    var result: Result<TestAPIMovie, APIError>?
    let exp = expectation(description: "fetch")
    client.fetch(resource: TestAPI.movie(failure: parsingError)) { response in
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
    let actualParsingError = innerError.jsonDecondingInnerError as? TestAPIError
    XCTAssertEqual(parsingInnerError, actualParsingError)
  }
  
}

private struct TestAPIMovie: Codable, Equatable {
  let name: String
}

private struct TestAPI {
  private init() { }

  static func movie() -> HTTPResource<TestAPIMovie> {
    return HTTPResource(
      path: "movie",
      method: .get,
      parse: mapObject
    )
  }
  
  static func find() -> HTTPResource<TestAPIMovie> {
    return HTTPResource(
      path: "movie",
      method: .post,
      parse: mapObject
    )
  }

  static func movie(responseObject: TestAPIMovie) -> HTTPResource<TestAPIMovie> {
    return HTTPResource(
      path: "movie",
      method: .get,
      parse: { _ in .success(responseObject) }
    )
  }
  
  static func movie(failure error: ParsingError) -> HTTPResource<TestAPIMovie> {
    return HTTPResource(
      path: "movie",
      method: .get,
      parse: { _ in .failure(error) }
    )
  }
}
