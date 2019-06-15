//
//  SecondViewController.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class ExploreVC: UIViewController {

  @IBOutlet private var collectionView: UICollectionView!

  private lazy var moviesCollectionController = MovieCollectionController(api: apiClient)
  private lazy var moviesCollectionLoadingController = MovieCollectionLoadingController()
  
  private var moviesList: MoviesListViewModel!
  private var apiClient: APIClient!
  private var imageFetcher: ImageFetcher!
  
  private var isInitialized = false
  
  private let detailsSequeIdentifier = "explore_details"
  
  func initialize(moviesList: MoviesListViewModel, apiClient: APIClient, imageFetcher: ImageFetcher) {
    guard !isInitialized else { return }
    
    self.moviesList = moviesList
    self.apiClient = apiClient
    self.imageFetcher = imageFetcher
    
    isInitialized = true
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    configureNavigationItem()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    configureNavigationItem()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard isInitialized else {
      fatalError("Must be initialized.")
    }
    
    configureMoviesTableView()
    
    bind()
    moviesList.loadNext()
  }
  
  private func configureNavigationItem() {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
  
  private func configureMoviesTableView() {
    moviesCollectionController.onCloseToEnd = { [weak self] in
      self?.moviesList.loadNext()
    }
  }
  
  private func bind() {
    moviesList.onChanged = { [weak self] in
      self?.update()
    }
    moviesList.onGoToDetails = { [weak self] movie in
      self?.goToDetails(movie)
    }
  }
  
  private func update() {
    switch moviesList.status {
    case .initial: break
    case .loading: configureForLoading()
    case .loaded: configureForLoaded()
    case .loadingNext: break
    case .failedToLoad: break
    case .failedToLoadNext: break
    }
  }
  
  private func configureForLoading() {
    if moviesCollectionLoadingController.collectionView !== collectionView {
      collectionView.isUserInteractionEnabled = false
      moviesCollectionLoadingController.collectionView = collectionView
    }
  }
  
  private func configureForLoaded() {
    moviesCollectionController.movies = moviesList.movies

    if moviesCollectionController.collectionView !== collectionView {
      collectionView.isUserInteractionEnabled = true
      moviesCollectionController.collectionView = collectionView
      UIView.transition(
        with: collectionView,
        duration: CATransaction.animationDuration(),
        options: .transitionCrossDissolve,
        animations: { },
        completion: nil
      )
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == detailsSequeIdentifier {
      guard let detailsVC = segue.destination as? MovieDetailsVC, let movie = sender as? Movie else {
        fatalError("Unexpected destination view controller.")
      }
      detailsVC.viewModel = MovieViewModelImpl(movie: movie, api: apiClient, imageFetcher: imageFetcher)
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
  
  private func goToDetails(_ movie: Movie) {
    self.performSegue(withIdentifier: detailsSequeIdentifier, sender: movie)
  }
}
