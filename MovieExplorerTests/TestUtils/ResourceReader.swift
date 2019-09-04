//
//  ResourceReader.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 9/9/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

struct ResourceNotFoundError: Error {
  let name: String
  let fileNameExtension: String
}

class ResourceReader {
  func read(named name: String, with fileNameExtension: String) throws -> Data {
    let bundle = Bundle(for: ResourceReader.self)
    guard let url = bundle.url(forResource: name, withExtension: fileNameExtension) else {
      throw ResourceNotFoundError(name: name, fileNameExtension: fileNameExtension)
    }
    
    return try Data(contentsOf: url)
  }
}
