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

  private let moviesCollectionController = ListController()
  private let moviesAdapter = MoviesAdapter()
  
  private var isLoading: Bool?
  
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
    
    moviesCollectionController.collectionView = collectionView

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
    moviesAdapter.onRetry = viewModel.retry
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
    moviesCollectionController.list = moviesAdapter.list(movies: viewModel.movies, status: viewModel.status)
    
    if isLoading != true {
      isLoading = true
      collectionView.isUserInteractionEnabled = false
    }
  }
  
  private func configureForLoaded() {
    moviesCollectionController.list = moviesAdapter.list(movies: viewModel.movies, status: viewModel.status)
    
    if isLoading != false {
      isLoading = false
      collectionView.isUserInteractionEnabled = true
      collectionView.mve.crossDissolveTransition { }
    }
  }
}
