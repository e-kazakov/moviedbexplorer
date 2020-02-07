//
//  MovieDetailsRelatedMoviesEmptyListItem.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 2/7/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsRelatedMoviesEmptyListItem: ListItem {
  
  func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
    collectionView.dequeueReusableCell(MovieDetailsRelatedMoviesEmptyCell.self, for: indexPath)
  }  
}
