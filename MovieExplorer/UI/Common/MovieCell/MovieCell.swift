//
//  MovieCell.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/16/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
  
  @IBOutlet var posterImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var overviewLabel: UILabel!
  @IBOutlet var releaseYearLabel: UILabel!
  
  private var viewModel: MovieCellViewModel?
  
  static let preferredHeight = CGFloat(198)
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    UILabel.Style.releaseYear(releaseYearLabel)
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

    if let imageVM = viewModel.image {
      posterImageView.image = imageVM.image ?? imageVM.placeholder
      posterImageView.alpha = imageVM.image == nil ? 0 : 1.0
      
      imageVM.onChanged = { [weak self, unowned imageVM] in
        if let image = imageVM.image {
          self?.posterImageView.image = image
          if (self?.posterImageView.alpha ?? 1.0) < CGFloat(1.0) {
            UIView.animate(withDuration: 0.3) { self?.posterImageView.alpha = 1.0 }
          }
        }
      }
      
      viewModel.image?.load()
    } else {
      posterImageView.image = nil;
    }
  }
}

extension MovieCell: NibLoadable, Reusable { }
