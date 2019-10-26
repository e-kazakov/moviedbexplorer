//
//  LabelListItem.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/24/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class LabelListItem: ListItem {
  
  private let text: String
  private let style: LabelCell.Style
  
  init(text: String, style: LabelCell.Style) {
    self.text = text
    self.style = style
  }
  
  func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(LabelCell.self, for: indexPath)
    cell.apply(style: style)
    cell.label.text = text
    return cell
  }
  
  func size(containerSize: CGSize) -> CGSize {
    LabelCell.preferredSize(withText: text, style: style, in: containerSize)
  }
}
