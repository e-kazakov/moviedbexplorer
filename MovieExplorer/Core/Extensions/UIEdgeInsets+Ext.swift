//
//  UIEdgeInsets+Ext.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 16.06.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
  var horizontal: CGFloat {
    return left + right
  }
  
  var vertical: CGFloat {
    return top + bottom
  }
}

extension UIEdgeInsets {
  static func horizontal(_ inset: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
  }

  static func vertical(_ inset: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
  }
}
