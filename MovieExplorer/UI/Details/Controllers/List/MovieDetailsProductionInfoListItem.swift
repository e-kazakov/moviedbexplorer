//
//  MovieDetailsProductionInfoListItem.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/26/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsProductionInfoListItem: ListItem {
    
  private let releaseYear: String
  private let duration: String
  
  init(releaseYear: String, duration: String) {
    self.releaseYear = releaseYear
    self.duration = duration
  }

  func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(MovieDetailsProductionInfoCell.self, for: indexPath)
    cell.releaseYearLabel.text = releaseYear
    cell.durationLabel.text = duration
    return cell
  }
  
  func size(containerSize: CGSize) -> CGSize {
    MovieDetailsProductionInfoCell.preferredSize(inContainer: containerSize)
  }
}
