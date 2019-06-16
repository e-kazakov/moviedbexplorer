//
//  SecondViewController.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class ExploreVC: UIViewController {

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .white
    return cv
  }()

  private lazy var moviesCollectionController = MovieCollectionController(api: apiClient)
  private lazy var moviesCollectionLoadingController = MovieCollectionLoadingController()
  
  private var moviesList: MoviesListViewModel
  private let apiClient: APIClient
  private let imageFetcher: ImageFetcher
  
  private let detailsSequeIdentifier = "explore_details"
  
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
    view = collectionView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureMoviesTableView()
    
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
    let vm = MovieViewModelImpl(movie: movie, api: apiClient, imageFetcher: imageFetcher)
    let detailsVC = MovieDetailsVC(viewModel: vm)
    show(detailsVC, sender: nil)
  }
}
