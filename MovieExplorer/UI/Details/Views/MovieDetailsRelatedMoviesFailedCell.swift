//
//  MovieDetailsRelatedMoviesFailedCell.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 1/6/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsRelatedMoviesFailedCell: UICollectionViewCell {
 
  var onRetry: (() -> Void)?
  
  private let messageLabel = UILabel.Style.errorMessage(UILabel())

  private let retryButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Retry", for: .normal)
    button.setTitleColor(.appLabel, for: .normal)
    button.tintColor = .label
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    setupConstraints()
    
    retryButton.addTarget(self, action: #selector(onRetryButtonTapped), for: .touchUpInside)
  }
  
  private func setupConstraints() {
    mve.addSubview(retryButton)
    
    NSLayoutConstraint.activate([
      retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      retryButton.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }
  
  @objc
  private func onRetryButtonTapped() {
    onRetry?()
  }
}
