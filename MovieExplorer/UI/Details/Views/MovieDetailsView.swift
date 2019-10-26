//
//  MovieDetailsView.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 16.06.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsView: UIView {
  
  let collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.vertical)
    cv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
    cv.backgroundColor = .appBackground
    return cv
  }()
  let errorView: ListErrorView = {
    let errorView = ListErrorView()
    errorView.title = "Failed to load movie"
    return errorView
  }()
  let loadingView = MovieDetailsLoadingView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
    style()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    mve.addSubview(collectionView)
    mve.addSubview(errorView)
    mve.addSubview(loadingView)
    
    errorView.isHidden = true
    loadingView.isHidden = true
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      collectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),

      errorView.topAnchor.constraint(equalTo: topAnchor),
      errorView.bottomAnchor.constraint(equalTo: bottomAnchor),
      errorView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
      errorView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),

      loadingView.topAnchor.constraint(equalTo: topAnchor),
      loadingView.bottomAnchor.constraint(equalTo: bottomAnchor),
      loadingView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
      loadingView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
    ])
  }
  
  private func style() {
    backgroundColor = .appBackground
  }
  
  func showLoading() {
    mve.crossDissolveTransition {
      self.errorView.isHidden = true
      self.loadingView.isHidden = false
    }
  }
  
  func showContent() {
    mve.crossDissolveTransition {
      self.errorView.isHidden = true
      self.loadingView.isHidden = true
    }
  }
  
  func showError() {
    mve.crossDissolveTransition {
      self.errorView.isHidden = false
      self.loadingView.isHidden = true
    }
  }
  
}
