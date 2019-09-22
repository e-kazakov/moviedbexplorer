//
//  URL+TestExt.swift
//  MovieExplorerTests
//
//  Created by Evgeny Kazakov on 03.10.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

extension URL {
  func queryParameter(_ name: String) -> String? {
    return URLComponents(url: self, resolvingAgainstBaseURL: true)?
      .queryItems?
      .first(where: { $0.name == name } )?
      .value
  }
}
