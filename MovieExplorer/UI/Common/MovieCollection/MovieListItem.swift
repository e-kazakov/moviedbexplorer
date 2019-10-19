//
//  MovieListItem.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/19/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieListItem: ListItem {
  
  private let movie: MovieCellViewModel
  
  init(movie: MovieCellViewModel) {
    self.movie = movie
  }
  
  func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(MovieCell.self, for: indexPath)
    cell.configure(with: movie)
    return cell
  }
  
  func size(containerSize: CGSize) -> CGSize {
    MovieCell.preferredSize(inContainer: containerSize)
  }
  
  func select() {
    movie.select()
  }
}
