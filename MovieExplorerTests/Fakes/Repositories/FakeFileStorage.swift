//
//  FakeFileStorage.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 03.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation
@testable import MovieExplorer

class FakeFileStorage: FileStorable {
  
  var data: Data?
  
  func write(_ data: Data) throws {
    self.data = data
  }
  
  func read() throws -> Data? {
    return data
  }
}
