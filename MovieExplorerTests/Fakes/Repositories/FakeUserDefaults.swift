//
//  FakeUserDefaults.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 7/23/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation
@testable import MovieExplorer

class FakeUserDefaults: UserDefaultsProtocol {
  
  var data: [String: Any] = [:]
  
  func stringArray(forKey defaultName: String) -> [String]? {
    return data[defaultName] as? [String]
  }
  
  func set(_ value: Any?, forKey defaultName: String) {
    data[defaultName] = value
  }
}
