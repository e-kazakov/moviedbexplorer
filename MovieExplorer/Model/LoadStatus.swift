//
//  LoadStatus.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/14/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

enum LoadStatus {
  case notLoaded
  case loading
  case loaded
  case error(Error)
  
  var isNotLoaded: Bool {
    switch self {
    case .notLoaded: return true
    default: return false
    }
  }
  
  var isLoading: Bool {
    switch self {
    case .loading: return true
    default: return false
    }
  }
  
  var isLoaded: Bool {
    switch self {
    case .loaded: return true
    default: return false
    }
  }
  
  var isError: Bool {
    switch self {
    case .error: return true
    default: return false
    }
  }
}
