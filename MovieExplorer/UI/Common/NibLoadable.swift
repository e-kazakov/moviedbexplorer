//
//  NibLoadable.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 4/7/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

protocol NibLoadable {
  
  static var nibName: String { get }
  
  static var nib: UINib { get }
}

extension NibLoadable where Self: UIView {
  
  static var nibName: String {
    return String(describing: self)
  }
  
  static var nib: UINib {
    return UINib(nibName: nibName, bundle: Bundle(for: self))
  }
  
  static func loadFromNib() -> Self? {
    for obj in nib.instantiate(withOwner: nil, options: nil) {
      if let view = obj as? Self {
        return view
      }
    }
    
    return nil
  }
}
