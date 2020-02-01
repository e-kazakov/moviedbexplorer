//
//  MovieDetailsActorCell.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/19/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsMemberCell: UICollectionViewCell {
  
  let initialsLabel: UILabel = {
    let label = UILabel()
    label.textColor = .appLabel
    label.textAlignment = .center
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    label.backgroundColor = .appPlaceholder
    label.layer.masksToBounds = true
    label.layer.cornerRadius = 4
    return label
  }()
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 4
    return imageView
  }()
  let nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .appLabel
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.textAlignment = .center
    return label
  }()
  let occupationLabel: UILabel = {
    let label = UILabel()
    label.textColor = .appLabel
    label.font = UIFont.preferredFont(forTextStyle: .footnote)
    label.textAlignment = .center
    return label
  }()
  
  private var viewModel: MoviePersonellMemberViewModel?
  private var reuseDisposable: Disposable?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
    style()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    contentView.mve.addSubview(initialsLabel)
    contentView.mve.addSubview(imageView)
    contentView.mve.addSubview(nameLabel)
    contentView.mve.addSubview(occupationLabel)
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.5),
      
      initialsLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
      initialsLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor),
      initialsLabel.rightAnchor.constraint(equalTo: imageView.rightAnchor),
      initialsLabel.heightAnchor.constraint(equalTo: imageView.heightAnchor),

      nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
      nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      
      occupationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
      occupationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      occupationLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
    ])
  }
  
  private func style() {
    backgroundColor = .appBackground
    imageView.tintColor = .appPlaceholder
  }

  func configure(with viewModel: MoviePersonellMemberViewModel) {
    self.viewModel = viewModel
    
    nameLabel.text = viewModel.name
    initialsLabel.text = viewModel.initials
    occupationLabel.text = viewModel.occupation
    if let photo = viewModel.photo {
      reuseDisposable = imageView.mve.setImage(photo)
    } else {
      imageView.isHidden = true
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    reuseDisposable?.dispose()
    reuseDisposable = nil
    imageView.layer.removeAllAnimations()
    imageView.isHidden = false
  }
}

extension MovieDetailsMemberCell: SizePreferrable {
  static func preferredSize(inContainer containerSize: CGSize) -> CGSize {
    CGSize(width: 125, height: containerSize.height)
  }
}
