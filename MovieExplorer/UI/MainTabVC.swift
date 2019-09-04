//
//  MainTabVC.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MainTabVC: UITabBarController, UITabBarControllerDelegate {

  private let apiClient: APIClient
  private let imageFetcher: ImageFetcher
  private let favorites: FavoriteMovies

  init(apiClient: APIClient, favorites: FavoriteMovies, imageFetcher: ImageFetcher) {
    self.apiClient = apiClient
    self.imageFetcher = imageFetcher
    self.favorites = favorites

    super.init(nibName: nil, bundle: nil)
    
    self.tabBar.tintColor = .black
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let moviesListViewModel = MoviesListViewModelImpl(
      moviesList: TMDBMoviesList(api: apiClient),
      api: apiClient,
      imageFetcher: imageFetcher
    )
    let favoritesListViewModel = FavoritesViewModelImpl(
      favorites: favorites,
      api: apiClient,
      imageFetcher: imageFetcher
    )
    
    let recentSearchesRepository = DefaultsRecentSearchesRepository(defaults: UserDefaults.standard)
    let searchViewModel = MovieSearchViewModelImpl(
      moviesSearch: TMDBMoviesSearch(api: apiClient, recentSearchesRepository: recentSearchesRepository),
      api: apiClient,
      imageFetcher: imageFetcher
    )

    let nc = { (rootVC: UIViewController) -> UINavigationController in
      let nc = UINavigationController(rootViewController: rootVC)
      nc.navigationBar.tintColor = .black
      return nc
    }
    
    self.viewControllers = [
      nc(ExploreVC(moviesList: moviesListViewModel, favorites: favorites, apiClient: apiClient, imageFetcher: imageFetcher)),
      nc(FavoritesVC(favoritesList: favoritesListViewModel, favorites: favorites, apiClient: apiClient, imageFetcher: imageFetcher)),
      nc(MovieSearchVC(viewModel: searchViewModel, favorites: favorites, apiClient: apiClient, imageFetcher: imageFetcher))
    ]
  }
}
