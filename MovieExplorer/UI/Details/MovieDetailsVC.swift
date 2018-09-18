//
//  MovieDeatilsVC.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsVC: UIViewController {
  
  @IBOutlet var posterImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var overviewLabel: UILabel!
  @IBOutlet var releaseYearLabel: UILabel! {
    didSet {
      releaseYearLabel?.layer.borderColor = UIColor(white: 151.0 / 255.0, alpha: 1.0).cgColor
      releaseYearLabel?.layer.borderWidth = 0.5
    }
  }
  
  var viewModel: MovieViewModel? {
    didSet {
      if isViewLoaded {
        bind()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    load()
  }

  private func bind() {
    guard let viewModel = viewModel else { return }
    
    title = viewModel.title
    nameLabel.text = viewModel.title
    overviewLabel.text = viewModel.overview
    releaseYearLabel.text = viewModel.releaseYear
    posterImageView.image = viewModel.image?.image ?? viewModel.image?.placeholder
    posterImageView.alpha = viewModel.image == nil ? 0 : 1.0
    
    viewModel.image?.onChanged = { [weak self] in
      if let image = viewModel.image?.image {
        self?.posterImageView.image = image
        if (self?.posterImageView.alpha ?? 1.0) < CGFloat(1.0) {
          UIView.animate(withDuration: 0.3) { self?.posterImageView.alpha = 1.0 }
        }
      }
    }
  }
  
  private func load() {
    viewModel?.image?.load()
  }
}
