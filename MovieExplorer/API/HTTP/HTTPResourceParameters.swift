//
//  APIResourceParameters.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol HTTPResourceParameters {
  func encode(in request: URLRequest) -> URLRequest
  
  func equals(other: HTTPResourceParameters) -> Bool
  func hash(into hasher: inout Hasher)
}

