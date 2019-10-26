//
//  ListController.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/19/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class ListController: NSObject {
  
  var onCloseToEnd: (() -> Void)?
  
  var screensOfContentToBeCloseToEnd: CGFloat = 1

  var list: List = .empty {
    didSet {
      reloadData()
    }
  }
  
  var collectionView: UICollectionView? {
    didSet {
      registerCollection()
    }
  }
  
  private func registerCollection() {
    guard let collectionView = collectionView else { return }
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.prefetchDataSource = self
  }
  
  private func reloadData() {
    collectionView?.reloadData()
  }
  
}

extension ListController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    list.sections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    list[section].items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    list[indexPath].cell(in: collectionView, at: indexPath)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      guard let header = list[indexPath.section].header else {
        fatalError("List model has no header")
      }
      return header.view(in: collectionView, ofKind: kind, at: indexPath)
      
    case UICollectionView.elementKindSectionFooter:
      guard let footer = list[indexPath.section].footer else {
        fatalError("List model has no footer")
      }
      return footer.view(in: collectionView, ofKind: kind, at: indexPath)
      
    default:
      fatalError("Unexpected supplementary view kind: \(kind)")
    }
  }
}

extension ListController: UICollectionViewDataSourcePrefetching {
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    indexPaths.forEach { list[$0].prefetch() }
  }
}

extension ListController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    var containerSize = collectionView.bounds.size
    containerSize.width -= list[indexPath.section].inset.horizontal
    return list[indexPath].size(containerSize: containerSize)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    let containerSize = collectionView.bounds.size
    return list[section].header?.size(containerSize: containerSize) ?? .zero
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    let containerSize = collectionView.bounds.size
    return list[section].footer?.size(containerSize: containerSize) ?? .zero
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    list[indexPath].select()
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    list[section].inset
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    list[section].minimumInteritemSpacing
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    list[section].minimumLineSpacing
  }
  
  // MARK: UIScrollViewDelegate
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if isCloseToEnd {
      onCloseToEnd?()
    }
  }
  
  private var isCloseToEnd: Bool {
    return distanceToEnd <= distanceToEndThreshold
  }
  
  private var distanceToEndThreshold: CGFloat {
    guard let cv = collectionView else { return 0 }
    
    return cv.bounds.height * screensOfContentToBeCloseToEnd
  }
  
  private var distanceToEnd: CGFloat {
    guard let cv = collectionView else { return 0 }

    return cv.contentSize.height - cv.bounds.size.height - cv.contentOffset.y
  }
}
