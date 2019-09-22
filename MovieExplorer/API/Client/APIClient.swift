//
//  APIClient.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 22.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol APIClient {

  @discardableResult
  func fetch<T: Decodable>(request: URLRequest,
                           callback: @escaping (Result<T, APIError>) -> Void) -> Disposable

  @discardableResult
  func fetch(request: URLRequest, callback: @escaping (Result<Void, APIError>) -> Void) -> Disposable

}
