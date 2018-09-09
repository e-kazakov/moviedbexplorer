//
//  Result.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

enum Result<Value, Error: Swift.Error> {
  case success(Value)
  case failure(Error)
}

extension Result {
  func mapError<E>(_ map: (Error) -> E) -> Result<Value, E> {
    switch self {
    case .success(let value):
      return .success(value)
    case .failure(let error):
      return .failure(map(error))
    }
  }
}

extension Result: Equatable where Value: Equatable, Error: Equatable {
  static func == (lhs: Result<Value, Error>, rhs: Result<Value, Error>) -> Bool {
    switch (lhs, rhs) {
    case (.success(let leftValue), .success(let rightValue)):
      return leftValue == rightValue
    
    case (.failure(let leftError), .failure(let rightError)):
      return leftError == rightError
    
    case (.success, .failure), (.failure, .success):
      return false
    }
  }
  
}
