//
//  MovieCell.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/16/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {

  static let preferredHeight = CGFloat(188)
  
  private let separatorView: UIView = {
    let separator = UIView()
    separator.backgroundColor = UIColor.black.withAlphaComponent(0.25)
    return separator
  }()
  private let disclosureImageView = UIImageView(image: UIImage.tmdb.angleRight)
  private let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    return label
  }()
  private let overviewLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 14, weight: .light)
    return label
  }()
  private let releaseYearLabel: UILabel = {
    let label = UILabel()
    UILabel.Style.releaseYear(label)
    return label
  }()

  private var viewModel: MovieCellViewModel?
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    setupSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    contentView.addSubview(separatorView)
    contentView.addSubview(disclosureImageView)
    contentView.addSubview(posterImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(overviewLabel)
    contentView.addSubview(releaseYearLabel)
    
    separatorView.translatesAutoresizingMaskIntoConstraints = false
    disclosureImageView.translatesAutoresizingMaskIntoConstraints = false
    posterImageView.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    overviewLabel.translatesAutoresizingMaskIntoConstraints = false
    releaseYearLabel.translatesAutoresizingMaskIntoConstraints = false
    
    nameLabel.setContentHuggingPriority(.required, for: .vertical)
    nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    disclosureImageView.setContentHuggingPriority(.required, for: .horizontal)
    disclosureImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
    overviewLabel.setContentHuggingPriority(.required, for: .vertical)

    NSLayoutConstraint.activate([
      posterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 2.0/3.0),
      posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
      nameLabel.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 12),
      nameLabel.rightAnchor.constraint(equalTo: disclosureImageView.leftAnchor, constant: -8),
      
      disclosureImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
      disclosureImageView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
      
      overviewLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
      overviewLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
      overviewLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor),
      overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: releaseYearLabel.topAnchor, constant: -10),
      
      releaseYearLabel.widthAnchor.constraint(equalToConstant: 60),
      releaseYearLabel.heightAnchor.constraint(equalToConstant: 20),
      releaseYearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      releaseYearLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
      
      separatorView.heightAnchor.constraint(equalToConstant: 1.0/UIScreen.main.scale),
      separatorView.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
      separatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
    ])
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    viewModel?.image?.onChanged = nil
    
    viewModel = nil
    posterImageView.image = nil
    nameLabel.text = nil
    overviewLabel.text = nil
    releaseYearLabel.text = nil
    
    posterImageView.layer.removeAllAnimations()
  }
  
  func configure(with viewModel: MovieCellViewModel) {
    self.viewModel = viewModel
    
    nameLabel.text = viewModel.title
    overviewLabel.text = viewModel.overview
    releaseYearLabel.text = viewModel.releaseYear

    posterImageView.tmdb.setImage(remote: viewModel.image)

    viewModel.image?.load()
  }
}

extension MovieCell: Reusable { }
