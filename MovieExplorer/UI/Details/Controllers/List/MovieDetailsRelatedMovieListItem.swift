//
//  MovieDetailsRelatedMovieListItem.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 1/6/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsRelatedMovieListItem: ListItem {
  
  var onSelect: (() -> Void)?

  private let movie: RelatedMovieCellViewModel
  
  init(movie: RelatedMovieCellViewModel) {
    self.movie = movie
  }
  
  func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(MovieDetailsRelatedMovieCell.self, for: indexPath)
    cell.configure(with: movie)
    return cell
  }
  
  func size(containerSize: CGSize) -> CGSize {
    MovieDetailsRelatedMovieCell.preferredSize(inContainer: containerSize)
  }
  
  func prefetch() {
    movie.poster?.load()
  }
  
  func select() {
    onSelect?()
  }
}
