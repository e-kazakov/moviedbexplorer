//
//  SecondViewController.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class ExploreVC: UIViewController {

  var goToMovieDetails: ((Movie) -> Void)?
  
  private let viewModel: MoviesListViewModel
  
  private lazy var contentView = ExploreView()
  private var collectionView: UICollectionView {
    return contentView.moviesListView
  }
  
  private let moviesCollectionController = MovieCollectionController()
  private let moviesCollectionLoadingController = MovieCollectionLoadingController()
  
  init (viewModel: MoviesListViewModel) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)

    configureNavigationItem()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bind()
    viewModel.loadNext()
  }
  
  private func configureNavigationItem() {
    title = "The Movie DB"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
  
  private func bind() {
    bindOutputs()
    bindInputs()
  }
  
  private func bindOutputs() {
    viewModel.onChanged = { [weak self] in
      self?.update()
    }
    viewModel.onGoToDetails = { [weak self] movie in
      self?.goToMovieDetails?(movie)
    }
  }
  
  private func bindInputs() {
    contentView.errorView.onRetry = viewModel.retry
    moviesCollectionController.onCloseToEnd = viewModel.loadNext
    moviesCollectionController.onRetry = viewModel.retry
  }
  
  private func update() {
    switch viewModel.status {
    case .initial:
      break

    case .loading:
      contentView.showList()
      configureForLoading()

    case .loaded, .loadingNext, .failedToLoadNext:
      contentView.showList()
      configureForLoaded()

    case .failedToLoad:
      contentView.showError()
    }
  }
  
  private func configureForLoading() {
    if moviesCollectionLoadingController.collectionView !== collectionView {
      collectionView.isUserInteractionEnabled = false
      moviesCollectionLoadingController.collectionView = collectionView
    }
  }
  
  private func configureForLoaded() {
    moviesCollectionController.viewModel = MovieCollectionViewModel(from: viewModel)
    
    if moviesCollectionController.collectionView !== collectionView {
      collectionView.isUserInteractionEnabled = true
      moviesCollectionController.collectionView = collectionView
      collectionView.mve.crossDissolveTransition { }
    }
  }

}

extension MovieCollectionViewModel {
  init(from moviesList: MoviesListViewModel) {
    switch moviesList.status {
    case .loadingNext:
      status = .loadingNext
    case .failedToLoadNext:
      status = .failedToLoadNext
    default:
      status = .loaded
    }
    
    movies = moviesList.movies
  }
}
