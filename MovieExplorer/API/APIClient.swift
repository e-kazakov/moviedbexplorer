//
//  ApiClient.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

enum PosterSize: String {
  case w92 = "w92"
  case w185 = "w185"
  case w500 = "w500"
  case w780 = "w780"
}

protocol APIClient {
  
  func posterURL(path: String, size: PosterSize) -> URL
  
  @discardableResult
  func fetch<T>(resource: HTTPResource<T>, callback: @escaping (Result<T, APIError>) -> Void) -> Disposable
}
