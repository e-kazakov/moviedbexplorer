//
//  ParsingError+TestExt.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 19.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

@testable import MovieExplorer

extension ParsingError {

  var isJSONDecondingError: Bool {
    switch self {
    case .jsonDecoding:
      return true
    }
  }
  
  var jsonDecondingInnerError: Error? {
    switch self {
    case .jsonDecoding(let inner):
      return inner
    }
  }
}
