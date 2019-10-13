//
//  FavoritesCoordinator.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 05.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class FavoritesCoordinator: BaseCoordinator {
    
  private let navigation: UINavigationController
  private let imageFetcher: ImageFetcher
  private let favorites: FavoriteMovies
  private let apiClient: APIClient
  
  init(navigation: UINavigationController, imageFetcher: ImageFetcher, favorites: FavoriteMovies, apiClient: APIClient) {
    self.navigation = navigation
    self.imageFetcher = imageFetcher
    self.favorites = favorites
    self.apiClient = apiClient
  }
  
  override func start() {
    super.start()
    
    let favoritesListViewModel = FavoritesViewModelImpl(
      favorites: favorites,
      imageFetcher: imageFetcher
    )
    let vc = FavoritesVC(viewModel: favoritesListViewModel)
    vc.goToMovieDetails = { [weak self] movie in
      self?.showDetails(movie)
    }
    navigation.viewControllers = [vc]
  }
  
  private func showDetails(_ movie: Movie) {
    let service = MovieDetailsAPIServiceImpl(client: apiClient)
    let vm = MovieDetailsViewModelImpl(movie: movie, movieDetailsService: service, favorites: favorites, imageFetcher: imageFetcher)
    let detailsVC = MovieDetailsVC(viewModel: vm)
    navigation.pushViewController(detailsVC, animated: true)
  }
}
