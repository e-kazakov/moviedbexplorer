//
//  ListListItem.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/24/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class ListListItem: ListItem {
  
  private let listController: ListController
  
  private let height: CGFloat
  
  private let reuseIdentifier: String?
  
  init(controller: ListController, height: CGFloat, reuseIdentifier: String? = nil) {
    listController = controller
    self.height = height
    self.reuseIdentifier = reuseIdentifier
  }
  
  func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
    let listCell = collectionView.dequeueReusableCell(
      ListCell.self,
      withReuseIdentifier: reuseIdentifier ?? ListCell.defaultReuseIdentifier,
      for: indexPath
    )
    listController.collectionView = listCell.listView
    return configure(listCell)
  }
  
  func size(containerSize: CGSize) -> CGSize {
    CGSize(width: containerSize.width, height: height)
  }
  
  private func configure(_ listCell: ListCell) -> ListCell {
    return listCell
  }
  
}
