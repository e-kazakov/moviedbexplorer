//
//  SecondViewController.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class ExploreVC: UIViewController {

  private let contentView = ExploreView()
  private var collectionView: UICollectionView {
    return contentView.moviesListView
  }
  private let moviesCollectionController = MovieCollectionController()
  private let moviesCollectionLoadingController = MovieCollectionLoadingController()
  
  private var moviesList: MoviesListViewModel
  private let apiClient: APIClient
  private let imageFetcher: ImageFetcher
  
  init (moviesList: MoviesListViewModel, apiClient: APIClient, imageFetcher: ImageFetcher) {
    self.moviesList = moviesList
    self.apiClient = apiClient
    self.imageFetcher = imageFetcher
    
    super.init(nibName: nil, bundle: nil)

    configureNavigationItem()
    configureTabBarItem()
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
    moviesList.loadNext()
  }
  
  private func configureNavigationItem() {
    title = "The Movie DB"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
  
  private func configureTabBarItem() {
    tabBarItem.title = "Explore"
    tabBarItem.image = UIImage.tmdb.popcornO
    tabBarItem.selectedImage = UIImage.tmdb.popcornFilled
  }
  
  private func bind() {
    bindOutputs()
    bindInputs()
  }
  
  private func bindOutputs() {
    moviesList.onChanged = { [weak self] in
      self?.update()
    }
    moviesList.onGoToDetails = { [weak self] movie in
      self?.goToDetails(movie)
    }
  }
  
  private func bindInputs() {
    contentView.errorView.onRetry = moviesList.retry
    moviesCollectionController.onCloseToEnd = moviesList.loadNext
    moviesCollectionController.onRetry = moviesList.retry
  }
  
  private func update() {
    switch moviesList.status {
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
    moviesCollectionController.viewModel = MovieCollectionViewModel(from: moviesList)
    
    if moviesCollectionController.collectionView !== collectionView {
      collectionView.isUserInteractionEnabled = true
      moviesCollectionController.collectionView = collectionView
      collectionView.tmdb.crossDissolveTransition { }
    }
  }
  
  private func goToDetails(_ movie: Movie) {
    let vm = MovieViewModelImpl(movie: movie, api: apiClient, imageFetcher: imageFetcher)
    let detailsVC = MovieDetailsVC(viewModel: vm)
    show(detailsVC, sender: nil)
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
