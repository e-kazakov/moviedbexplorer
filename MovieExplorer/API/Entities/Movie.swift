//
//  Movie.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

struct Movie: Codable {
  
  let posterPath: String?
  let title: String
  let releaseDate: String
  let overview: String
  
  private enum CodingKeys: String, CodingKey {
    case posterPath = "poster_path"
    case title = "title"
    case releaseDate = "release_date"
    case overview = "overview"
  }
}
