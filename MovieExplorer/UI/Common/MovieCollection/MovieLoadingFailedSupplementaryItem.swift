//
//  MovieLoadingFailedSupplementaryItem.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/19/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieLoadingFailedSupplementaryItem: ListSupplementaryItem {
  
  var onRetry: (() -> Void)?
  
  func view(in collectionView: UICollectionView, ofKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let view = collectionView.dequeueReusableSupplementaryView(MovieFailedCell.self, ofKind: kind, forIndexPath: indexPath)
    view.onRetry = { [weak self] in self?.onRetry?() }
    return view
  }
  
  func size(containerSize: CGSize) -> CGSize {
    MovieFailedCell.preferredSize(inContainer: containerSize)
  }
}

