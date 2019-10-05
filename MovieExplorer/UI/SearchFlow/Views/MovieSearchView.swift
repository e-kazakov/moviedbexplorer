//
//  MovieSearchView.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 07.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieSearchView: UIView {
  
  let moviesListView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .appBackground
    return cv
  }()
  let recentSearchesListView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .appSecondaryBackground
    return cv
  }()
  
  let initialView = MovieSearchInitialView()
  let emptyView = MovieSearchEmptyView()
  let errorView: ListErrorView = {
    let errorView = ListErrorView()
    errorView.title = "Failed to search results"
    errorView.message = "Please retry"
    errorView.retryButtonTitle = "Retry"
    return errorView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .appBackground
    
    setupSubviews()
    hideAll(except: initialView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func showInitial() {
    guard initialView.isHidden else { return }

    hideAll(except: initialView)
  }
  
  func showEmpty() {
    guard emptyView.isHidden else { return }

    hideAll(except: emptyView)
  }
  
  func showError() {
    guard errorView.isHidden else { return }

    hideAll(except: errorView)
  }
  
  func showList() {
    guard moviesListView.isHidden else { return }
    
    hideAll(except: moviesListView)
  }
  
  func showLastSearches() {
    guard recentSearchesListView.isHidden else { return }
    
    hideAll(except: recentSearchesListView)
  }
  
  private func hideAll(except toShow: UIView) {
    mve.crossDissolveTransition {
      self.subviews.forEach { subview in
        subview.isHidden = true
      }
      toShow.isHidden = false
    }
  }
  
  private func setupSubviews() {
    addSubview(moviesListView)
    addSubview(recentSearchesListView)
    addSubview(initialView)
    addSubview(emptyView)
    addSubview(errorView)

    moviesListView.translatesAutoresizingMaskIntoConstraints = false
    recentSearchesListView.translatesAutoresizingMaskIntoConstraints = false
    initialView.translatesAutoresizingMaskIntoConstraints = false
    emptyView.translatesAutoresizingMaskIntoConstraints = false
    errorView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      moviesListView.topAnchor.constraint(equalTo: topAnchor),
      moviesListView.bottomAnchor.constraint(equalTo: bottomAnchor),
      moviesListView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
      moviesListView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
      
      recentSearchesListView.topAnchor.constraint(equalTo: topAnchor),
      recentSearchesListView.bottomAnchor.constraint(equalTo: bottomAnchor),
      recentSearchesListView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
      recentSearchesListView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),

      initialView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      initialView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      initialView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
      initialView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
      
      emptyView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      emptyView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      emptyView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
      emptyView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),

      errorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      errorView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      errorView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
      errorView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
    ])
  }
  
}
