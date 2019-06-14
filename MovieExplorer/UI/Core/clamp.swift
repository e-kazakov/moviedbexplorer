//
//  clamp.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 15.06.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

func clamp<T: Comparable>(_ val: T, _ lower: T, _ upper: T) -> T {
  return max(lower, min(val, upper))
}
