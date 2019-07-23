//
//  Reusable.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 4/7/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

protocol Reusable {
  static var defaultReuseIdentifier: String { get }
}

extension Reusable {
  static var defaultReuseIdentifier: String {
    return String(describing: self)
  }
}
