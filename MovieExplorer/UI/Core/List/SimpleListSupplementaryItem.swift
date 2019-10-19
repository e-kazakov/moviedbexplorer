//
//  SimpleListItem.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/19/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class SimpleListSupplementaryItem<T: UICollectionReusableView & Reusable & SizePreferrable>: ListSupplementaryItem {
 
  func view(
    in collectionView: UICollectionView,
    ofKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    collectionView.dequeueReusableSupplementaryView(T.self, ofKind: kind, forIndexPath: indexPath)
  }
  
  func size(containerSize: CGSize) -> CGSize {
    T.preferredSize(inContainer: containerSize)
  }
  
}
