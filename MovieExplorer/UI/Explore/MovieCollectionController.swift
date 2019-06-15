//
//  MovieTableController.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieCollectionController: NSObject, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout {
  
  var onCloseToEnd: (() -> Void)?
  
  let screensOfContentToBeClose = 1 as CGFloat
  
  var collectionView: UICollectionView? = nil {
    didSet {
      configureTableView()
    }
  }
  
  var movies: [MovieCellViewModel] = [] {
    didSet {
      if movies.count != oldValue.count {
        collectionView?.reloadData()
      }
    }
  }
  
  private let apiClient: APIClient
  
  init(api: APIClient) {
    apiClient = api
  }
  
  private func configureTableView() {
    guard let cv = collectionView else { return }
    
    cv.register(MovieCell.nib, forCellWithReuseIdentifier: MovieCell.defaultReuseIdentifier)
    
    cv.delegate = self
    cv.prefetchDataSource = self
    cv.dataSource = self
  }
  
  // MARK: DataSource
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movies.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let movie = movies[indexPath.row]
    let movieCell = self.movieCell(collectionView: collectionView, at: indexPath)
    
    movieCell.configure(with: movie)
    
    return movieCell

  }
  
  private func movieCell(collectionView: UICollectionView, at indexPath: IndexPath) -> MovieCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.defaultReuseIdentifier,
                                                  for: indexPath)
    guard let movieCell = cell as? MovieCell else {
      fatalError("Unexpected type of reused cell. Expecting \(MovieCell.self), got \(type(of: cell))")
    }
    return movieCell
  }
  
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    indexPaths
      .map { movies[$0.row] }
      .forEach { $0.image?.load() }
  }
  
  // MARK: Delegate

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width - collectionView.adjustedContentInset.horizontal
    return CGSize(width: width, height: MovieCell.preferredHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    movies[indexPath.row].select()
  }
  
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
    
    return cv.bounds.height * screensOfContentToBeClose
  }
  
  private var distanceToEnd: CGFloat {
    guard let cv = collectionView else { return 0 }

    return cv.contentSize.height - cv.bounds.size.height - cv.contentOffset.y
  }
}
