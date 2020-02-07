//
//  MovieDetailsRelatedMoviesFailedListItem.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 1/6/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsRelatedMoviesFailedListItem: ListItem {
  
  var onRetry: (() -> Void)?
  
  func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(MovieFailedCell.self, for: indexPath)
    cell.message = "Failed to load"
    cell.onRetry = { [weak self] in self?.onRetry?() }
    return cell
  }
}
