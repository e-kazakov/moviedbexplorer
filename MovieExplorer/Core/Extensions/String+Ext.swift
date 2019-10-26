//
//  String+Ext.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/26/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

extension String {
  var emptyAsNil: String? {
    if isEmpty {
      return nil
    } else {
      return self
    }
  }
}
