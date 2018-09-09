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
  
  func test_RequestWithoutQueryItems_CreatesRequestWithQueryItems() {
    let request = URLRequest(url: URL(string: "http://example.com/path")!)
    
    let queryParameters = URLQueryParameters(["answer" : "42"])
    let actualResult = queryParameters.encode(in: request)
    
    XCTAssertEqual(URL(string: "http://example.com/path?answer=42"), actualResult.url)
  }
  
  func test_QueryItemWithNonURLSymbols_UsesPercentEncoding() {
    let request = URLRequest(url: URL(string: "http://example.com/path")!)
    
    let queryParameters = URLQueryParameters(["answer" : " 42"])
    let actualResult = queryParameters.encode(in: request)
    
    XCTAssertEqual(URL(string: "http://example.com/path?answer=%2042"), actualResult.url)
  }

  func test_EmptyParameters_DoesNotRemoteExistingQueryItems() {
    let request = URLRequest(url: URL(string: "http://example.com/path?answer=42")!)
    
    let queryParameters = URLQueryParameters([:])
    let actualResult = queryParameters.encode(in: request)
    
    XCTAssertEqual(URL(string: "http://example.com/path?answer=42"), actualResult.url)
  }
  
  func test_RequestWithExistingQueryItems_DoesNotModifyExistingQueryItems() {
    let request = URLRequest(url: URL(string: "http://example.com/path?some=value")!)
    
    let queryParameters = URLQueryParameters(["answer" : "42"])
    let actualResult = queryParameters.encode(in: request)
    
    XCTAssertEqual(URL(string: "http://example.com/path?some=value&answer=42"), actualResult.url)
  }
  
}
