//
//  MovieDeatilsVC.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsVC: UIViewController {
  
  private let viewModel: MovieDetailsViewModel

  private let detailsView = MovieDetailsView()

  init(viewModel: MovieDetailsViewModel) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)
    
    configureNavigationItem()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = detailsView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bind()
    load()
    update()
  }
  
  private func configureNavigationItem() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.mve.starO,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(onToggleFavorite))
  }

  private func bind() {
    bindOutputs()
    bindInputs()
  }
  
  private func bindOutputs() {
    viewModel.onChanged = { [weak self] in
      self?.update()
    }
  }
  
  private func bindInputs() {
    detailsView.errorView.onRetry = viewModel.load
  }
  
  private func update() {
    switch viewModel.status {
    case .initial, .loading:
      detailsView.showLoading()
    case .loaded:
      detailsView.showContent()
    case .error:
      detailsView.showError()
    }
    
    title = viewModel.title
    detailsView.infoView.nameLabel.text = viewModel.title
    detailsView.infoView.overviewLabel.text = viewModel.overview
    detailsView.infoView.releaseYearLabel.text = viewModel.releaseYear
    detailsView.infoView.durationLabel.text = viewModel.duration
    detailsView.infoView.taglineLabel.text = viewModel.tagline
    detailsView.infoView.taglineLabel.isHidden = viewModel.tagline == nil
    detailsView.infoView.genresLabel.text = viewModel.genres
    detailsView.infoView.posters = viewModel.posters
    detailsView.infoView.images = viewModel.images
    
    let favButton = UIBarButtonItem(
      image: viewModel.isFavorite ? UIImage.mve.starFilled : UIImage.mve.starO,
      style: .plain,
      target: self,
      action: #selector(onToggleFavorite)
    )
    navigationItem.setRightBarButton(favButton, animated: true)
  }
  
  private func load() {
    viewModel.load()
  }

  // MARK: Actions
  
  @objc
  private func onToggleFavorite() {
    viewModel.toggleFavorite()
  }
}
