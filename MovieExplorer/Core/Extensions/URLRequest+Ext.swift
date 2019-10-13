//
//  URLRequest+Ext.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 7/23/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

extension URLRequest {
  
  mutating func appendQueryItem(_ queryItem: URLQueryItem) {
    appendQueryItems([queryItem])
  }
  
  mutating func appendQueryItems<S>(_ queryItems: S) where S: Sequence, S.Element == URLQueryItem {
    url = url?.appendingQueryItems(queryItems)
  }
  
  mutating func appendRawQueryItems(_ rawItem: [String: String]) {
    appendQueryItems(rawItem.map(URLQueryItem.init))
  }

}

extension URLRequest {
  
  init(path: String) {
    self.init(url: URL(string: path)!)
  }

}
