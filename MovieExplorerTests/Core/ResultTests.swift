//
//  ResultTests.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 9/15/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import XCTest
@testable import MovieExplorer

class ResultTests: XCTestCase {
  
  func testEquals_EqualSuccessResults_ReturnsTrue() {
    let lhs = Result<Int, SomeError>.success(42)
    let rhs = Result<Int, SomeError>.success(42)
    
    XCTAssertTrue(lhs == rhs)
  }
  
  func testEquals_NonEqualSuccessResults_ReturnsFalse() {
    let lhs = Result<Int, SomeError>.success(42)
    let rhs = Result<Int, SomeError>.success(43)
    
    XCTAssertFalse(lhs == rhs)
  }
  
  func testEquals_EqualFailureResults_ReturnsTrue() {
    let lhs = Result<Int, SomeError>.failure(SomeError(code: 42))
    let rhs = Result<Int, SomeError>.failure(SomeError(code: 42))
    
    XCTAssertTrue(lhs == rhs)
  }

  func testEquals_NonEqualFailureResults_ReturnsFalse() {
    let lhs = Result<Int, SomeError>.failure(SomeError(code: 42))
    let rhs = Result<Int, SomeError>.failure(SomeError(code: 43))
    
    XCTAssertFalse(lhs == rhs)
  }
  
  func testEquals_OppositeCases_ReturnsFalse() {
    let lhs = Result<Int, SomeError>.success(42)
    let rhs = Result<Int, SomeError>.failure(SomeError(code: 43))
    
    XCTAssertFalse(lhs == rhs)
  }

  func testMapError_SuccessResult_ReturnsSuccessCase() {
    let original = Result<Int, SomeError>.success(42)
    let expectedResult = Result<Int, OtherError>.success(42)
    
    let actualResult = original.mapError { OtherError(code: $0.code) }
    
    XCTAssertEqual(expectedResult, actualResult)
  }
  
  func testMapError_FailureResult_ReturnsFailureCaseWithTransformedError() {
    let original = Result<Int, SomeError>.failure(SomeError(code: 42))
    let expectedResult = Result<Int, OtherError>.failure(OtherError(code: 42))

    let actualResult = original.mapError { OtherError(code: $0.code) }
    
    XCTAssertEqual(expectedResult, actualResult)
  }
  
}

private struct SomeError: Error, Equatable {
  let code: Int
}

private struct OtherError: Error, Equatable {
  let code: Int
}
