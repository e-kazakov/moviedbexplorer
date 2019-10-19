//
//  List.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/19/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

protocol ListItem {
  
  func cell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    
  func size(containerSize: CGSize) -> CGSize

  func prefetch()
  
  func select()
}

extension ListItem {
  func prefetch() { }
  func select() { }
}

protocol ListSupplementaryItem {
  
  func view(in collectionView: UICollectionView, ofKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
  
  func size(containerSize: CGSize) -> CGSize
}

struct ListSection {
  let header: ListSupplementaryItem?
  let items: [ListItem]
  let footer: ListSupplementaryItem?
  
  var inset: UIEdgeInsets = .zero
  var minimumLineSpacing: CGFloat = 0
  var minimumInteritemSpacing: CGFloat = 0

  subscript(index: Int) -> ListItem {
    items[index]
  }
}

extension ListSection {
  init(_ items: [ListItem]) {
    self.init(header: nil, items: items, footer: nil)
  }
}

struct List {
  let sections: [ListSection]
  
  subscript(indexPath: IndexPath) -> ListItem {
    sections[indexPath.section][indexPath.item]
  }
  
  subscript(sectionIndex: Int) -> ListSection {
    sections[sectionIndex]
  }
}

extension List {
  static let empty = List(sections: [])
}
