//
//  MainTabsCoordinator.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 05.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MainTabsCoordinator: BaseCoordinator {
  
  private let apiClient: APIClient
  private let imageFetcher: ImageFetcher
  private let favorites: FavoriteMovies
  private let navigation: UINavigationController
  
  private var exploreCoordinator: ExploreCoordinator?
  private var favoritesCoordinator: FavoritesCoordinator?
  private var searchCoordinator: SearchCoordinator?
  
  init(navigation: UINavigationController, apiClient: APIClient, imageFetcher: ImageFetcher, favorites: FavoriteMovies) {
    self.navigation = navigation
    self.apiClient = apiClient
    self.imageFetcher = imageFetcher
    self.favorites = favorites
  }
  
  override func start() {
    super.start()

    let vc = MainTabVC()
    vc.onSelectExplore = { [weak self] nc in
      self?.startExploreFlow(navigation: nc)
    }
    vc.onSelectFavorites = { [weak self] nc in
      self?.startFavoritesFlow(navigation: nc)
    }
    vc.onSelectSearch = { [weak self] nc in
      self?.startSearchFlow(navigation: nc)
    }
    navigation.viewControllers = [vc]
  }
  
  private func startExploreFlow(navigation nc: UINavigationController) {
    guard exploreCoordinator == nil else { return }

    let exploreCoordinator = ExploreCoordinator(navigation: nc, apiClient: apiClient, imageFetcher: imageFetcher, favorites: favorites)
    self.exploreCoordinator = exploreCoordinator
    
    startSubflow(exploreCoordinator)
  }

  private func startFavoritesFlow(navigation nc: UINavigationController) {
    guard favoritesCoordinator == nil else { return }

    let favoritesCoordinator = FavoritesCoordinator(navigation: nc, imageFetcher: imageFetcher, favorites: favorites, apiClient: apiClient)
    self.favoritesCoordinator = favoritesCoordinator
    
    startSubflow(favoritesCoordinator)
  }

  private func startSearchFlow(navigation nc: UINavigationController) {
    guard searchCoordinator == nil else { return }

    let searchCoordinator = SearchCoordinator(navigation: nc, apiClient: apiClient, imageFetcher: imageFetcher, favorites: favorites)
    self.searchCoordinator = searchCoordinator
    
    startSubflow(searchCoordinator)
  }

}
