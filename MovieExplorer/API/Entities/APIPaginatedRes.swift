//
//  APIPaginatedRes.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

struct APIPaginatedRes<Wrapped: Codable>: Codable {
  
  let page: Int
  let results: [Wrapped]
  let totalResults: Int
  let totalPages: Int
  
  private enum CodingKeys: String, CodingKey {
    case page = "page"
    case results = "results"
    case totalResults = "total_results"
    case totalPages = "total_pages"
  }
}
