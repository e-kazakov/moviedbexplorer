//
//  APIError+TestExt.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 19.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

@testable import MovieExplorer

extension APIError {
  var isNetworkError: Bool {
    switch self {
    case .network:
      return true
    default:
      return false
    }
  }
  
  var networkInnerError: Error? {
    switch self {
    case .network(let inner):
      return inner
    default:
      return nil
    }
  }
  
  var isJSONMappingError: Bool {
    switch self {
    case .jsonMapping:
      return true
    default:
      return false
    }
  }
  
  var jsonMappingInnerError: ParsingError? {
    switch self {
    case .jsonMapping(let inner):
      return inner
    default:
      return nil
    }
  }
}
