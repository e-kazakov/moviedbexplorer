//
//  FavoritesVC.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {

  private lazy var contentView = FavoritesView()
  private var collectionView: UICollectionView {
    return contentView.moviesListView
  }

  private let moviesCollectionController = MovieCollectionController()
  private let moviesCollectionLoadingController = MovieCollectionLoadingController()
  
  private let favoritesList: FavoritesViewModel
  private let favorites: FavoriteMovies
  private let apiClient: APIClient
  private let imageFetcher: ImageFetcher

  init (favoritesList: FavoritesViewModel, favorites: FavoriteMovies, apiClient: APIClient, imageFetcher: ImageFetcher) {
    self.favoritesList = favoritesList
    self.apiClient = apiClient
    self.imageFetcher = imageFetcher
    self.favorites = favorites
    
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
    
    moviesCollectionController.collectionView = collectionView

    bind()
    update()
  }
  
  private func configureNavigationItem() {
    title = "Favorites"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
  
  private func configureTabBarItem() {
    tabBarItem.title = "Favorites"
    tabBarItem.image = UIImage.tmdb.starO
    tabBarItem.selectedImage = UIImage.tmdb.startFilled
  }
  
  private func bind() {
    bindOutputs()
  }
  
  private func bindOutputs() {
    favoritesList.onChanged = { [weak self] in
      self?.update()
    }
    favoritesList.onGoToDetails = { [weak self] movie in
      self?.goToDetails(movie)
    }
  }
  
  private func update() {
    moviesCollectionController.viewModel = MovieCollectionViewModel(from: favoritesList)
    
    if favoritesList.movies.isEmpty {
      contentView.showInitial()
    } else {
      contentView.showList()
    }
  }
  
  private func goToDetails(_ movie: Movie) {
    let vm = MovieViewModelImpl(movie: movie, favorites: favorites, imageFetcher: imageFetcher, api: apiClient)
    let detailsVC = MovieDetailsVC(viewModel: vm)
    show(detailsVC, sender: nil)
  }
}

extension MovieCollectionViewModel {
  init(from moviesList: FavoritesViewModel) {
    status = .loaded
    movies = moviesList.movies
  }
}
