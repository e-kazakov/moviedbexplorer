//
//  URLQueryParametersTests.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 9/9/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import XCTest
@testable import MovieExplorer

class URLQueryParametersTests: XCTestCase {
  
  func testEncode_RequestWithoutQueryItems_CreatesRequestWithQueryItems() {
    // given
    let request = URLRequest(url: URL(string: "http://example.com/path")!)
    let queryParameters = URLQueryParameters(["answer" : "42"])
    let expectedURL = URL(string: "http://example.com/path?answer=42")

    // when
    let encodedRequest = queryParameters.encode(in: request)
    
    // then
    XCTAssertEqual(expectedURL, encodedRequest.url)
  }
  
  func testEncode_QueryItemWithNonURLSymbols_UsesPercentEncoding() {
    // given
    let request = URLRequest(url: URL(string: "http://example.com/path")!)
    let queryParameters = URLQueryParameters(["answer" : " 42"])
    let expectedURL = URL(string: "http://example.com/path?answer=%2042")
    
    // when
    let encodedRequest = queryParameters.encode(in: request)
    
    // then
    XCTAssertEqual(expectedURL, encodedRequest.url)
  }

  func testEncode_EmptyParameters_DoesNotRemoteExistingQueryItems() {
    // given
    let request = URLRequest(url: URL(string: "http://example.com/path?answer=42")!)
    let queryParameters = URLQueryParameters([:])
    let expectedURL = URL(string: "http://example.com/path?answer=42")

    // when
    let encodedRequest = queryParameters.encode(in: request)
    
    // then
    XCTAssertEqual(expectedURL, encodedRequest.url)
  }
  
  func testEncode_RequestWithExistingQueryItems_DoesNotModifyExistingQueryItems() {
    // given
    let request = URLRequest(url: URL(string: "http://example.com/path?some=value")!)
    let queryParameters = URLQueryParameters(["answer" : "42"])
    let expectedURL = URL(string: "http://example.com/path?some=value&answer=42")

    // when
    let encodedRequest = queryParameters.encode(in: request)
    
    // then
    XCTAssertEqual(expectedURL, encodedRequest.url)
  }
  
}
