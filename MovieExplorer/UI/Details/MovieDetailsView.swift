//
//  MovieDetailsView.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 16.06.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsView: UIView {
  
  let posterImageView = UIImageView()
  let nameLabel = UILabel.Style.title(UILabel())
  let overviewLabel = UILabel.Style.info(UILabel())
  let releaseYearLabel = UILabel.Style.releaseYear(UILabel())
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    posterImageView.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    overviewLabel.translatesAutoresizingMaskIntoConstraints = false
    releaseYearLabel.translatesAutoresizingMaskIntoConstraints = false
    
    self.addSubview(posterImageView)
    self.addSubview(nameLabel)
    self.addSubview(overviewLabel)
    self.addSubview(releaseYearLabel)
    
    NSLayoutConstraint.activate([
      posterImageView.topAnchor.constraint(equalTo: self.topAnchor),
      posterImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
      posterImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
      posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),
      
      nameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
      nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
      nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
      
      overviewLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
      overviewLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
      overviewLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
      
      releaseYearLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 30),
      releaseYearLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
      releaseYearLabel.widthAnchor.constraint(equalToConstant: 60),
      releaseYearLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
    ])
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
