//
//  Movie+Random.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 16.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation
@testable import MovieExplorer

extension Movie {
  static var random: Movie {
    return Movie(
      id: Int(arc4random()),
      posterPath: UUID().uuidString,
      title: UUID().uuidString,
      releaseDate: UUID().uuidString,
      overview: UUID().uuidString
    )
  }
}
