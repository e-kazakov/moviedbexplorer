//
//  UIView+Ext.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/26/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

extension MVE where Base: UIView {
  func addSubview(_ subview: UIView) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    base.addSubview(subview)
  }
}

extension UIView {
  
  convenience init(color: UIColor) {
    self.init()
    
    backgroundColor = color
  }
  
}
