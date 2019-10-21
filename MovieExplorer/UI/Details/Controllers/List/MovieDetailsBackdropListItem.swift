//
//  MovieDetailsBackdropListItem.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/22/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsBackdropListItem: ListItem {
  
  private let image: ImageViewModel
  
  private let aspectRatio = AspectRatio.backdrop
  
  init(image: ImageViewModel) {
    self.image = image
  }
  
  func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(ImageCell.self, for: indexPath)
    cell.configure(with: image)
    cell.imageView.layer.cornerRadius = 4
    return cell
  }
  
  func size(containerSize: CGSize) -> CGSize {
    aspectRatio.size(forHeight: containerSize.height)
  }
}
