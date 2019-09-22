//
//  ParsingError+TestExt.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 19.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

@testable import MovieExplorer

extension ParsingError {

  var isNoDataError: Bool {
    if case .noData = self {
      return true
    } else {
      return false
    }
  }
  
  var isJSONDecondingError: Bool {
    if case .jsonDecoding = self {
      return true
    } else {
      return false
    }
  }
  
  var jsonDecondingInnerError: Error? {
    switch self {
    case .jsonDecoding(let inner):
      return inner
    default:
      return nil
    }
  }
}
