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
  private let detailsListAdapter = MovieDetailsListAdapter()
  private let detailsListController = ListController()

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
    
    detailsListController.collectionView = detailsView.collectionView

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
    
    detailsListController.list = detailsListAdapter.list(viewModel)

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
