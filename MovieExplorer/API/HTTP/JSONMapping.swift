//
//  JSONMapping.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

func mapObject<T>(from data: Data) -> Result<T, ParsingError> where T: Decodable {
  do {
    let parsedData = try JSONDecoder().decode(T.self, from: data)
    return .success(parsedData)
  } catch {
    return .failure(.jsonDecoding(inner: error))
  }
}
