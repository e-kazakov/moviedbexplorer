//
//  UICollectionView+Create.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/22/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

extension UICollectionView {
  static var horizontalList: UICollectionView {
    UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.horizontal)
  }

  static var verticalList: UICollectionView {
    UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.vertical)
  }
}
