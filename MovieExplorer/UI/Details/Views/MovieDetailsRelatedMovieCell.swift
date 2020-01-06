//
//  MovieDetailsRelatedMovieCell.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 1/6/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsRelatedMovieCell: UICollectionViewCell {
  
  let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 4
    return imageView
  }()
  let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.textColor = .appLabel
    label.font = UIFont.preferredFont(forTextStyle: .footnote)
    label.textAlignment = .center
    return label
  }()
  
  private var viewModel: RelatedMovieCellViewModel?
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
    contentView.mve.addSubview(posterImageView)
    contentView.mve.addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      posterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      posterImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      posterImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.5),

      titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
      titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
      titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
    ])
  }
  
  private func style() {
    backgroundColor = .appBackground
    posterImageView.tintColor = .appPlaceholder
  }

  func configure(with viewModel: RelatedMovieCellViewModel) {
    self.viewModel = viewModel
    
    titleLabel.text = viewModel.title
    reuseDisposable = posterImageView.mve.setImage(viewModel.poster)
    
    viewModel.poster?.load()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    reuseDisposable?.dispose()
    reuseDisposable = nil
    posterImageView.layer.removeAllAnimations()
  }
}

extension MovieDetailsRelatedMovieCell: SizePreferrable {
  static func preferredSize(inContainer containerSize: CGSize) -> CGSize {
    CGSize(width: 125, height: containerSize.height)
  }
}
