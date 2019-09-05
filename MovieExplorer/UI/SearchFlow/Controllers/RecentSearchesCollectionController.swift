//
//  RecentSearchesCollectionController.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 20.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class RecentSearchesCollectionController: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  var onSelect: ((String) -> Void)?
  
  var recentSearches: [String] = [] {
    didSet {
      collectionView?.reloadData()
    }
  }
  
  var collectionView: UICollectionView? = nil {
    didSet {
      configureCollectionView()
    }
  }

  private func configureCollectionView() {
    guard let cv = collectionView else { return }
    
    cv.register(RecentSearchQueryCell.self, forCellWithReuseIdentifier: RecentSearchQueryCell.defaultReuseIdentifier)
    
    cv.dataSource = self
    cv.delegate = self
  }
  
  // MARK: DataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return recentSearches.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchQueryCell.defaultReuseIdentifier, for: indexPath)
    guard let queryCell = cell as? RecentSearchQueryCell else {
      fatalError("Unexpected type of reused cell. Expecting \(RecentSearchQueryCell.self), got \(type(of: cell))")
    }

    queryCell.text = recentSearches[indexPath.item]
    
    return queryCell
  }
  
  // MARK: Delegate
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width - collectionView.adjustedContentInset.horizontal
    return CGSize(width: width, height: RecentSearchQueryCell.preferredHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    onSelect?(recentSearches[indexPath.item])
  }


}
