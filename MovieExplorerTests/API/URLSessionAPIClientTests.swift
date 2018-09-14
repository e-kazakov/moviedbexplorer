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
    let actualURL = client.posterURL(path: "42", size: .w780)

    let expectedURL = URL(string: "http://image.example.com/w780/42")!
    XCTAssertEqual(expectedURL, actualURL)
  }
  
  func testFetch_Resource_ConstructsRequestWithCorrectHTTPMethod() {
    let resource = TestAPI.find()
    client.fetch(resource: resource) { _ in }
    guard let req = sessionMock.lastRequest, let httpMethod = req.httpMethod else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(resource.method.rawValue, httpMethod)
  }
  
  func testFetch_Resource_ResumesTheDataTask() {
    let dataTask = FakeURLSessionDataTask()
    sessionMock.nextDataTask = dataTask
    
    client.fetch(resource: TestAPI.movie()) { _ in }
    
    XCTAssertTrue(dataTask.isResumed, "Data task should be resumed.")
  }
  
  func testFetch_Resource_AppendsApiKeyQueryItem() {
    let apiKeyQueryItem = URLQueryItem(name: URLSessionAPIClient.apiKeyQueryItemName, value: testServerConfig.apiKey)

    client.fetch(resource: TestAPI.movie()) { _ in }
    
    guard
      let request = sessionMock.lastRequest,
      let url = request.url,
      let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
      else {
        XCTFail("")
        return
      }

    let queryItems = components.queryItems ?? []
    XCTAssertTrue(
      queryItems.contains(apiKeyQueryItem),
      "Query part of the request URL should contain api key."
    )
  }
  
  func testFetch_ResourceWithResponseData_ParsesReturnedData() {
    let movie = TestAPIMovie(name: "Avengers")
    let jsonString = "{ \"name\": \"Avengers\" }"
    let jsonData = jsonString.data(using: .utf8)!
    
    sessionMock.nextResponse = FakeResponse(data: jsonData)
    
    let exp = expectation(description: "")
    client.fetch(resource: TestAPI.movie()) { result in
      exp.fulfill()
      
      switch result {
      case .success(let parsedMovie):
        XCTAssertEqual(movie, parsedMovie)
        
      case .failure(let error):
        XCTFail("Fetch failed with error. \(error)")
      }
    }

    waitForExpectations(timeout: 1.0)
  }
  
  func testFetch_DataTaskError_ReturnsFailureWithNetworkError() {
    let requestError = TestAPIError.anError
    sessionMock.nextResponse = FakeResponse(error: requestError)

    let exp = expectation(description: "")
    client.fetch(resource: TestAPI.movie()) { result in
      exp.fulfill()
      
      switch result {
      case .success:
        XCTFail("Fetch should fail with with error.")
        
      case .failure(let error):
        switch error {
        case .network(let innerError):
          guard let actualError = innerError as? TestAPIError else {
            XCTFail("Inner error should be \(requestError)")
            return
          }
          XCTAssertEqual(requestError, actualError)
        
        default:
          XCTFail("Fetch should fail with \(APIError.network(inner: requestError)) error. Actual - \(error)")
        }
      }
    }
    
    waitForExpectations(timeout: 1.0)
  }
  
  func testFetch_ParsingError_ReturnsFailureWithMappingError() {
    sessionMock.nextResponse = FakeResponse(data: Data())
    let parsingError = ParsingError.jsonDecoding(inner: TestAPIError.anError)
    
    let exp = expectation(description: "")
    client.fetch(resource: TestAPI.movie(failure: parsingError)) { result in
      exp.fulfill()
      
      switch result {
      case .success:
        XCTFail("Fetch should fail with with error.")
        
      case .failure(let error):
        switch error {
        case .jsonMapping(let innerError):
          switch innerError {
          case .jsonDecoding(let actualParsingError):
            guard let actualParsingError = actualParsingError as? TestAPIError else {
              XCTFail("Inner error should be \(TestAPIError.anError)")
              return
            }
            
            XCTAssertEqual(TestAPIError.anError, actualParsingError)
          }
          
        default:
          XCTFail("Fetch should fail with \(APIError.jsonMapping(inner: parsingError)) error. Actual - \(error)")
        }
      }
    }
    
    waitForExpectations(timeout: 1.0)
  }
  
}

struct TestAPIMovie: Codable, Equatable {
  let name: String
}

enum TestAPIError: Error, Equatable {
  case anError
}

struct TestAPI {
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
