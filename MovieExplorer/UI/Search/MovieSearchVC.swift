//
//  FirstViewController.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieSearchVC: UIViewController {

  private let apiClient: APIClient
  private let imageFetcher: ImageFetcher
  private var viewModel: MovieSearchViewModel
  
  private let moviesCollectionController = MovieCollectionController()
  private let moviesCollectionLoadingController = MovieCollectionLoadingController()
  
  private let searchBar = UISearchBar()
  private lazy var contentView = MovieSearchView()
  private var moviesListView: UICollectionView {
    return contentView.moviesListView
  }
  
  init(viewModel: MovieSearchViewModel, apiClient: APIClient, imageFetcher: ImageFetcher) {
    self.viewModel = viewModel
    self.apiClient = apiClient
    self.imageFetcher = imageFetcher
    
    super.init(nibName: nil, bundle: nil)
    
    configureNavigationItem()
    configureTabBarItem()
    
    searchBar.delegate = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureNavigationItem() {
    title = "Search"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.titleView = searchBar
  }
  
  private func configureTabBarItem() {
    tabBarItem.title = "Search"
    tabBarItem.image = UIImage.tmdb.magnifyingGlass
    tabBarItem.selectedImage = UIImage.tmdb.magnifyingGlassThick
  }
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bind()
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
      self?.goToDetails(movie)
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
      contentView.showInitial()

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
    if moviesCollectionLoadingController.collectionView !== moviesListView {
      moviesCollectionController.collectionView = nil
      moviesListView.contentOffset = .zero
      
      moviesListView.isUserInteractionEnabled = false
      moviesCollectionLoadingController.collectionView = moviesListView
      moviesListView.tmdb.crossDissolveTransition { }
    }
  }
  
  private func configureForLoaded() {
    moviesCollectionController.viewModel = MovieCollectionViewModel(from: viewModel)
    
    if moviesCollectionController.collectionView !== moviesListView {
      moviesCollectionLoadingController.collectionView = nil
      moviesListView.contentOffset = .zero

      moviesListView.isUserInteractionEnabled = true
      moviesCollectionController.collectionView = moviesListView
      moviesListView.tmdb.crossDissolveTransition { }
    }
    
    if viewModel.movies.isEmpty {
      contentView.showEmpty()
    }
  }
  
  private func goToDetails(_ movie: Movie) {
    let vm = MovieViewModelImpl(movie: movie, api: apiClient, imageFetcher: imageFetcher)
    let detailsVC = MovieDetailsVC(viewModel: vm)
    show(detailsVC, sender: nil)
  }
}

extension MovieSearchVC: UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(true, animated: true)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let query = searchBar.text, !query.isEmpty {
      viewModel.search(query: query)
    } else {
      viewModel.cancel()
    }
    
    searchBar.setShowsCancelButton(false, animated: true)
    searchBar.endEditing(true)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = viewModel.searchQuery

    searchBar.endEditing(true)
    searchBar.setShowsCancelButton(false, animated: true)
  }
}

extension MovieCollectionViewModel {
  init(from moviesList: MovieSearchViewModel) {
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
