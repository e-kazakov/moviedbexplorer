//
//  MovieDetailsSecondaryTitleListItem.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/28/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsSecondaryTitleListItem: ListItem {
  
  private let style = LabelCell.Style.movieDetailsMembersTitleStyle
  private let title: String
  
  init(title: String) {
    self.title = title
  }
  
  func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
    let header = collectionView.dequeueReusableCell(LabelCell.self, for: indexPath)
    header.label.text = self.title
    header.apply(style: style)
    return header
  }
  
  func size(containerSize: CGSize) -> CGSize {
    LabelCell.preferredSize(withText: title, style: style, in: containerSize)
  }
}
