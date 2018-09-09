//
//  APIError.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

enum APIError: Error {
  case noData
  case jsonMapping(inner: ParsingError)
  case unknown(inner: Error?)
}
