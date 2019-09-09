//
//  MovieTableLoadingController.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 5/30/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieCollectionLoadingController: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  var collectionView: UICollectionView? = nil {
    didSet {
      configureCollectionView()
    }
  }

  private let loadingCellsCount = 10
  
  private func configureCollectionView() {
    guard let cv = collectionView else { return }
    guard let layout = cv.collectionViewLayout as? UICollectionViewFlowLayout else {
      fatalError("Expecting UICollectionViewFlowLayout. Got \(cv.collectionViewLayout)")
    }
    
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0

    cv.register(MovieSkeletonCell.self,
                forCellWithReuseIdentifier: MovieSkeletonCell.defaultReuseIdentifier)

    cv.delegate = self
    cv.dataSource = self
    cv.prefetchDataSource = nil
  }
  
  // MARK: DataSource
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return loadingCellsCount
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(withReuseIdentifier: MovieSkeletonCell.defaultReuseIdentifier,
                                              for: indexPath)
  }
  
  // MARK: Delegate

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width - collectionView.adjustedContentInset.horizontal
    return CGSize(width: width, height: MovieSkeletonCell.preferredHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      willDisplay cell: UICollectionViewCell,
                      forItemAt indexPath: IndexPath) {
    guard let skeletonCell = cell as? MovieSkeletonCell else {
      return
    }
    skeletonCell.startAnimation()
  }
}
