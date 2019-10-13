//
//  Image.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 06.10.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

struct Image: Codable, Equatable {
  
  let aspectRatio: Float
  let path: String
  let height: Int
  let width: Int
  
  private enum CodingKeys: String, CodingKey {
    case aspectRatio = "aspect_ratio"
    case path = "file_path"
    case height = "height"
    case width = "width"
  }
  
}
