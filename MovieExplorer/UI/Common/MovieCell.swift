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
  
  private var viewModel: MovieViewModel?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    UILabel.Style.releaseYear(releaseYearLabel)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    viewModel?.onChange = nil
    viewModel?.cancel()
    
    viewModel = nil
    posterImageView.image = nil
    nameLabel.text = nil
    overviewLabel.text = nil
    releaseYearLabel.text = nil
  }
  
  func configure(with viewModel: MovieViewModel) {
    self.viewModel = viewModel
    
    nameLabel.text = viewModel.title
    overviewLabel.text = viewModel.overview
    releaseYearLabel.text = viewModel.releaseYear
    posterImageView.image = viewModel.image
    viewModel.onChange = { [weak self] in
      self?.posterImageView.image = viewModel.image
    }
  }
}

extension MovieCell: NibLoadable, Reusable { }

protocol NibLoadable {
  
  static var nibName: String { get }
  
  static var nib: UINib { get }
}

extension NibLoadable where Self: UIView {
  
  static var nibName: String {
    return String(describing: self)
  }
  
  static var nib: UINib {
    return UINib(nibName: nibName, bundle: Bundle(for: self))
  }
}

protocol Reusable {
  static var defaultReuseIdentifier: String { get }
}

extension Reusable {
  static var defaultReuseIdentifier: String {
    return String(describing: self)
  }
}
