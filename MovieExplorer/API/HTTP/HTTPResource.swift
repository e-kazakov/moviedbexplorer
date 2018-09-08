//
//  ApiResource.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

struct HTTPResource<T> {
  
  let path: String
  let method: HTTPMethod
  let parameters: HTTPResourceParameters?
  let parse: (Data) -> Result<T, ParsingError>
  
  init(
    path: String,
    method: HTTPMethod,
    parameters: HTTPResourceParameters? = nil,
    parse: @escaping (Data) -> Result<T, ParsingError>
  ) {
    self.path = path
    self.method = method
    self.parameters = parameters
    self.parse = parse
  }
  
}
