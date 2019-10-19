//
//  SizePreferrable.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/19/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import struct CoreGraphics.CGSize

protocol SizePreferrable {
  static func preferredSize(inContainer containerSize: CGSize) -> CGSize
}
