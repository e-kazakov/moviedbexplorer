//
//  MovieDetailsRelatedMoviesEmptyCell.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 2/7/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsRelatedMoviesEmptyCell: UICollectionViewCell {
  
  private let messageLabel = UILabel.Style.emptyRelated(UILabel())

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    setupConstraints()
    
    messageLabel.text = #"¯\_(ツ)_/¯"#
  }
  
  private func setupConstraints() {
    mve.addSubview(messageLabel)
    
    NSLayoutConstraint.activate([
      messageLabel.topAnchor.constraint(equalTo: topAnchor),
      messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
      messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
}
