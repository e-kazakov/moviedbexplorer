//
//  MovieDetailsView.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 16.06.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsView: UIView {
  
  let infoView = MovieDetailsInfoView()
  let errorView: ListErrorView = {
    let errorView = ListErrorView()
    errorView.title = "Failed to load movie"
    return errorView
  }()
  let loadingView = MovieDetailsLoadingView()

  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
    return scrollView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
    style()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    infoView.translatesAutoresizingMaskIntoConstraints = false
    errorView.translatesAutoresizingMaskIntoConstraints = false
    loadingView.translatesAutoresizingMaskIntoConstraints = false
    
    scrollView.addSubview(infoView)
    addSubview(scrollView)
    addSubview(errorView)
    addSubview(loadingView)
    
    errorView.isHidden = true
    loadingView.isHidden = true
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
      scrollView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
      scrollView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),

      infoView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      infoView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
      infoView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
      infoView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      infoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      
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
