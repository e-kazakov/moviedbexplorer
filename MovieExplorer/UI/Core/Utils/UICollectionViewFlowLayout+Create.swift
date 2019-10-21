//
//  UICollectionViewFlowLayout+Create.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/22/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
  static var horizontal: UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    return layout
  }
  
  static var vertical: UICollectionViewFlowLayout {
    UICollectionViewFlowLayout()
  }
}
