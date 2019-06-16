//
//  TMDBCompatible.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 16.06.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation.NSObject

struct TMDB<Base> {
  let base: Base
}

protocol TMDBCompatible {
  associatedtype Base
  
  static var tmdb: TMDB<Base>.Type { get }
  var tmdb: TMDB<Base> { get }
}

extension TMDBCompatible {
  static var tmdb: TMDB<Self>.Type {
    return TMDB<Self>.self
  }
  
  var tmdb: TMDB<Self> {
    return TMDB(base: self)
  }
}

extension NSObject: TMDBCompatible { }
