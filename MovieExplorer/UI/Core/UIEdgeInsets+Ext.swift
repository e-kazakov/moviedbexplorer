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
