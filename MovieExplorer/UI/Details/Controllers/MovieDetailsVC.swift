//
//  MovieDeatilsVC.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsVC: UIViewController {
  
  var goToMovieDetails: ((Movie) -> Void)?

  private let viewModel: MovieDetailsViewModel

  private let detailsView = MovieDetailsView()
  
  private lazy var detailsListAdapter = MovieDetailsListAdapter(
    similarMoviesAdapter: similarMoviesListAdapter,
    similarMoviesController: similarMoviesListController,
    recommendedMoviesAdapter: recommendedMoviesListAdapter,
    recommendedMoviesController: recommendedMoviesListController
  )
  private let detailsListController = ListController()
  
  private let similarMoviesListAdapter = MovieDetailsRelatedMoviesListAdapter()
  private let similarMoviesListController = ListController()
  private let recommendedMoviesListAdapter = MovieDetailsRelatedMoviesListAdapter()
  private let recommendedMoviesListController = ListController()

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
    let changeHandler: () -> Void = { [weak self] in
      self?.update()
    }
    let navigateToDetails: (Movie) -> Void = { [weak self] movie in
      self?.goToMovieDetails?(movie)
    }
    
    viewModel.onChanged = changeHandler

    viewModel.similarMovies.onGoToDetails = navigateToDetails
    viewModel.recommendedMovies.onGoToDetails = navigateToDetails
  }
  
  private func bindInputs() {
    detailsView.errorView.onRetry = viewModel.load
    
    recommendedMoviesListAdapter.onRetry = viewModel.recommendedMovies.retry
    recommendedMoviesListController.onCloseToEnd = viewModel.recommendedMovies.loadNext
    
    similarMoviesListAdapter.onRetry = viewModel.similarMovies.retry
    similarMoviesListController.onCloseToEnd = viewModel.similarMovies.loadNext
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
    viewModel.recommendedMovies.loadNext()
    viewModel.similarMovies.loadNext()
  }

  // MARK: Actions
  
  @objc
  private func onToggleFavorite() {
    viewModel.toggleFavorite()
  }
}
