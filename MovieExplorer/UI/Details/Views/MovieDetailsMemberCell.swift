//
//  MovieDetailsActorCell.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/19/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsMemberCell: UICollectionViewCell {
  
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
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
    style()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    contentView.mve.addSubview(imageView)
    contentView.mve.addSubview(nameLabel)
    contentView.mve.addSubview(occupationLabel)
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.5),

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
    occupationLabel.text = viewModel.occupation
    imageView.mve.setImage(viewModel.photo)
    
    viewModel.photo.load()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    viewModel?.photo.onChanged = nil
    imageView.layer.removeAllAnimations()
  }
}

extension MVE where Base: UIView {
  func addSubview(_ subview: UIView) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    base.addSubview(subview)
  }
}

extension MovieDetailsMemberCell: SizePreferrable {
  static func preferredSize(inContainer containerSize: CGSize) -> CGSize {
    CGSize(width: 125, height: containerSize.height)
  }
}
