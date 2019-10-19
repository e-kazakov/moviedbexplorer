//
//  RecentSearchQueryListItem.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/19/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class RecentSearchQueryListItem: ListItem {
  
  var onSelect: (() -> Void)?
  
  private let query: String
  
  init(query: String) {
    self.query = query
  }
  
  func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(RecentSearchQueryCell.self, for: indexPath)
    cell.text = query
    return cell
  }
  
  func size(containerSize: CGSize) -> CGSize {
    RecentSearchQueryCell.preferredSize(inContainer: containerSize)
  }
  
  func select() {
    onSelect?()
  }
    
}
