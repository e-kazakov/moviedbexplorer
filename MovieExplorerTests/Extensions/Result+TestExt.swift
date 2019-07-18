//
//  Result+TestExt.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 19.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

extension Result {
  var isSuccess: Bool {
    if case .success = self {
      return true
    } else {
      return false
    }
  }
  
  var isFailure: Bool {
    if case .failure = self {
      return true
    } else {
      return false
    }
  }
  
  func tryGetValue() -> Success? {
    switch self {
    case .success(let value):
      return value
    case .failure:
      return nil
    }
  }
  
  func tryGetError() -> Failure? {
    switch self {
    case .success:
      return nil
    case .failure(let error):
      return error
    }
  }
}
