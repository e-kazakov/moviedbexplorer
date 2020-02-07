//
//  MovieDetailsProductionInfoCell.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/26/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsProductionInfoCell: UICollectionViewCell {
  
  let releaseYearLabel = UILabel.Style.releaseYear(UILabel())
  let durationLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
    style()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
      style()
    }
  }

  private func setupSubviews() {
    contentView.mve.addSubview(releaseYearLabel)
    contentView.mve.addSubview(durationLabel)
    
    NSLayoutConstraint.activate([
      releaseYearLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      releaseYearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      releaseYearLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
      releaseYearLabel.widthAnchor.constraint(equalToConstant: 60),
      
      durationLabel.centerYAnchor.constraint(equalTo: releaseYearLabel.centerYAnchor),
      durationLabel.leftAnchor.constraint(equalTo: releaseYearLabel.rightAnchor, constant: 10),
    ])
  }
  
  private func style() {
    UILabel.Style.releaseYear(releaseYearLabel)
  }
}

extension MovieDetailsProductionInfoCell: SizePreferrable {
  static func preferredSize(inContainer containerSize: CGSize) -> CGSize {
    CGSize(width: containerSize.width, height: 20)
  }
}
