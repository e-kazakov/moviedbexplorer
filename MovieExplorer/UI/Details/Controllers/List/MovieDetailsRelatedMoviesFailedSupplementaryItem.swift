//
//  MovieDetailsRelatedMoviesFailedSupplementaryItem.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 1/7/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsRelatedMoviesFailedSupplementaryItem: ListSupplementaryItem {
  
  var onRetry: (() -> Void)?
  
  func view(in collectionView: UICollectionView, ofKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let view = collectionView.dequeueReusableSupplementaryView(MovieFailedCell.self, ofKind: kind, forIndexPath: indexPath)
    view.onRetry = { [weak self] in self?.onRetry?() }
    return view
  }
  
  func size(containerSize: CGSize) -> CGSize {
    CGSize(width: 125, height: containerSize.height)
  }
}

