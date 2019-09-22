//
//  JSONMapping.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

func mapJSON<T>(from data: Data?) -> Result<T, ParsingError> where T: Decodable {
  return mapJSON(from: data, using: JSONDecoder())
}

func mapJSON<T>(from data: Data?, using decoder: JSONDecoder) -> Result<T, ParsingError> where T: Decodable {
  guard let data = data else {
    return .failure(.noData)
  }
  
  do {
    let parsedData = try decoder.decode(T.self, from: data)
    return .success(parsedData)
  } catch {
    return .failure(.jsonDecoding(inner: error))
  }
}
