//
//  ExploreView.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 22.06.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class ExploreView: UIView {
  
  lazy private(set) var moviesListView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .white
    return cv
  }()
  lazy private(set) var errorView: ExploreErrorView = {
    let ev = ExploreErrorView()
    ev.backgroundColor = .white
    ev.isHidden = true
    return ev
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    addSubview(moviesListView)
    addSubview(errorView)
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    moviesListView.translatesAutoresizingMaskIntoConstraints = false
    errorView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      moviesListView.topAnchor.constraint(equalTo: topAnchor),
      moviesListView.bottomAnchor.constraint(equalTo: bottomAnchor),
      moviesListView.leftAnchor.constraint(equalTo: leftAnchor),
      moviesListView.rightAnchor.constraint(equalTo: rightAnchor),
      
      errorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      errorView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      errorView.leftAnchor.constraint(equalTo: leftAnchor),
      errorView.rightAnchor.constraint(equalTo: rightAnchor),
    ])
  }
  
  func showError() {
    errorView.tmdb.crossDissolveTransition {
      self.errorView.isHidden = false
    }
  }
  
  func showList() {
    errorView.tmdb.crossDissolveTransition {
      self.errorView.isHidden = true
    }
  }
}
