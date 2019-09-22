//
//  URL+Ext.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 7/23/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

extension URL {
  
  func appendingQueryItems<S>(_ queryItems: S) -> URL where S: Sequence, S.Element == URLQueryItem {
    guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
      return self
    }
    
    var requestQueryItems = components.queryItems ?? []
    requestQueryItems.append(contentsOf: queryItems)
    components.queryItems = requestQueryItems
    
    return components.url ?? self
  }
  
}
