//
//  UserDefaultsProtocol.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 03.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol UserDefaultsProtocol {
  func stringArray(forKey defaultName: String) -> [String]?
  func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol { }
