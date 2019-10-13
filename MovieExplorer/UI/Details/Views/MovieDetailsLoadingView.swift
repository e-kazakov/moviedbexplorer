//
//  MovieDetailsLoadingView.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 08.10.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsLoadingView: UIView {
  
  private let loadingIndicator = UIActivityIndicatorView(style: .large)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
    style()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    loadingIndicator.startAnimating()
    
    addSubview(loadingIndicator)
    
    NSLayoutConstraint.activate([
      loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }
  
  private func style() {
    backgroundColor = .appBackground
    loadingIndicator.tintColor = .appPlaceholder
  }
}
