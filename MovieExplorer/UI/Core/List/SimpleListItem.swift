//
//  SimpleListItem.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/19/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class SimpleListItem<T: UICollectionViewCell & Reusable & SizePreferrable>: ListItem {
  
  func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
    collectionView.dequeueReusableCell(T.self, for: indexPath)
  }
  
  func size(containerSize: CGSize) -> CGSize {
    T.preferredSize(inContainer: containerSize)
  }
}

