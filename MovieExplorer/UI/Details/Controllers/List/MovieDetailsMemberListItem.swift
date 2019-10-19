//
//  MovieDetailsMemberListItem.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/19/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsMemberListItem: ListItem {
  
  var onSelect: (() -> Void)?
  
  private let member: MoviePersonellMemberViewModel
  
  init(member: MoviePersonellMemberViewModel) {
    self.member = member
  }
  
  func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(MovieDetailsMemberCell.self, for: indexPath)
    cell.configure(with: member)
    return cell
  }
  
  func size(containerSize: CGSize) -> CGSize {
    MovieDetailsMemberCell.preferredSize(inContainer: containerSize)
  }
  
  func prefetch() {
    member.photo.load()
  }
  
  func select() {
    onSelect?()
  }
  
}
