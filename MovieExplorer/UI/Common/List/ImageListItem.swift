//
//  ImageListItem.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/26/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class ImageListItem: ListItem {
  
  struct Style {
    let aspectRatio: AspectRatio
    let cornerRadius: CGFloat
  }
  
  private let image: ImageViewModel
  private let style: Style
  
  init(image: ImageViewModel, style: Style) {
    self.image = image
    self.style = style
  }
  
  func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(ImageCell.self, for: indexPath)
    cell.configure(with: image)
    cell.imageView.layer.cornerRadius = style.cornerRadius
    return cell
  }
  
  func size(containerSize: CGSize) -> CGSize {
    style.aspectRatio.size(forHeight: containerSize.height)
  }
  
  func prefetch() {
    image.load()
  }
}
