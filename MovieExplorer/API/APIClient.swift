//
//  ApiClient.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol APIClient {
  
  @discardableResult
  func fetch<T>(resource: HTTPResource<T>, callback: @escaping (Result<T, APIError>) -> Void) -> Disposable
}
