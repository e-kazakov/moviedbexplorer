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
      UILabel.Style.releaseYear(releaseYearLabel)
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
  }

  private func bind() {
    guard let viewModel = viewModel else { return }
    
    title = viewModel.title
    nameLabel.text = viewModel.title
    overviewLabel.text = viewModel.overview
    releaseYearLabel.text = viewModel.releaseYear
    posterImageView.image = viewModel.image
    viewModel.onChange = { [weak self] in
      self?.posterImageView.image = viewModel.image
    }
  }
}
