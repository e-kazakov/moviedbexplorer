//
//  MovieTableController.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

struct MovieCollectionViewModel {
  enum Status {
    case loaded, loadingNext, failedToLoadNext
  }
  
  static let empty = MovieCollectionViewModel(movies: [], status: .loaded)
  
  let movies: [MovieCellViewModel]
  let status: Status
}

class MovieCollectionController: NSObject, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout {
  
  var onCloseToEnd: (() -> Void)?
  var onRetry: (() -> Void)?
  
  let screensOfContentToBeCloseToEnd = 1 as CGFloat
  
  var collectionView: UICollectionView? = nil {
    didSet {
      configureCollectionView()
    }
  }
  
  var viewModel: MovieCollectionViewModel = .empty {
    didSet {
      movies = viewModel.movies
      collectionView?.reloadData()
    }
  }
  
  private var movies: [MovieCellViewModel] = []
  
  private let moviesSectionInedx = 0
  private let loadingSectionIndex = 1
  
  private func configureCollectionView() {
    guard let cv = collectionView else { return }
    guard let layout = cv.collectionViewLayout as? UICollectionViewFlowLayout else {
      fatalError("Expecting UICollectionViewFlowLayout. Got \(cv.collectionViewLayout)")
    }
    
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0

    cv.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.defaultReuseIdentifier)
    cv.register(MovieSkeletonCell.self, forCellWithReuseIdentifier: MovieSkeletonCell.defaultReuseIdentifier)
    cv.register(MovieFailedCell.self, forCellWithReuseIdentifier: MovieFailedCell.defaultReuseIdentifier)

    cv.dataSource = self
    cv.delegate = self
    cv.prefetchDataSource = self
  }
  
  // MARK: DataSource
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    if viewModel.status == .loaded {
      return 1
    } else {
      return 2
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case moviesSectionInedx:
      return movies.count
    case loadingSectionIndex:
      return 1
    default:
      fatalError("Unexpected number of sections")
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.section {
    case moviesSectionInedx:
      let cell = movieCell(collectionView: collectionView, at: indexPath)
      cell.configure(with: movies[indexPath.row])
      return cell

    case loadingSectionIndex:
      if viewModel.status == .loadingNext {
        return loadingCell(collectionView: collectionView, at: indexPath)
      } else {
        return loadingFailedCell(collectionView: collectionView, at: indexPath)
      }

    default:
      fatalError("Unexpected section index \(indexPath.section)")
    }
  }
  
  private func movieCell(collectionView: UICollectionView, at indexPath: IndexPath) -> MovieCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.defaultReuseIdentifier,
                                                  for: indexPath)
    guard let movieCell = cell as? MovieCell else {
      fatalError("Unexpected type of reused cell. Expecting \(MovieCell.self), got \(type(of: cell))")
    }
    return movieCell
  }
  
  private func loadingCell(collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(withReuseIdentifier: MovieSkeletonCell.defaultReuseIdentifier,
                                              for: indexPath)
  }

  private func loadingFailedCell(collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
    let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: MovieFailedCell.defaultReuseIdentifier,
                                                   for: indexPath)
    
    guard let failedCell = cell as? MovieFailedCell else {
      fatalError("Unexpected type of reused cell. Expecting \(MovieFailedCell.self), got \(type(of: cell))")
    }
    
    failedCell.onRetry = onRetry
    
    return failedCell
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
    
    switch indexPath.section {
    case moviesSectionInedx:
      return CGSize(width: width, height: MovieCell.preferredHeight)

    case loadingSectionIndex:
      if viewModel.status == .loadingNext {
        return CGSize(width: width, height: MovieSkeletonCell.preferredHeight)
      } else {
        return CGSize(width: width, height: MovieFailedCell.preferredHeight)
      }
      
    default:
      fatalError("Unexpected section index \(indexPath.section)")
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    movies[indexPath.row].select()
  }
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return indexPath.section == moviesSectionInedx
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      willDisplay cell: UICollectionViewCell,
                      forItemAt indexPath: IndexPath) {
    if let skeletonCell = cell as? MovieSkeletonCell {
      skeletonCell.startAnimation()
    }
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
    
    return cv.bounds.height * screensOfContentToBeCloseToEnd
  }
  
  private var distanceToEnd: CGFloat {
    guard let cv = collectionView else { return 0 }

    return cv.contentSize.height - cv.bounds.size.height - cv.contentOffset.y
  }
}
