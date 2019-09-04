//
//  Array+Ext.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 20.08.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
  
  mutating func remove(_ element: Element) {
    if let index = firstIndex(of: element) {
      remove(at: index)
    }
  }
  
}
