//
//  MainTabVC.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MainTabVC: UITabBarController, UITabBarControllerDelegate {

  private var apiClient: APIClient!
  private var imageFetcher: ImageFetcher!

  override var selectedViewController: UIViewController? {
    didSet {
      configureSelectedController()
    }
  }
  
  private var isInitialized = false
  
  func initialize(apiClient: APIClient, imageFetcher: ImageFetcher) {
    guard !isInitialized else { return }
    
    self.apiClient = apiClient
    self.imageFetcher = imageFetcher
    isInitialized = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard isInitialized else {
      fatalError("Must be initialized.")
    }
  }
  
  private func configureSelectedController() {
    guard let selectedViewController = selectedViewController else { return }
    guard let selectedNavigationController = selectedViewController as? UINavigationController else {
      fatalError("Unexpected controller type.")
    }
    
    guard let rootVC = selectedNavigationController.viewControllers.first else { return }
    
    switch rootVC {
    case let explore as ExploreVC:
      let moviesListViewModel = MoviesListViewModelImpl(
        moviesList: TMDBMoviesList(api: apiClient),
        api: apiClient,
        imageFetcher: imageFetcher
      )
      explore.initialize(moviesList: moviesListViewModel, apiClient: apiClient, imageFetcher: imageFetcher)
    case let search as MovieSearchVC:
      print("Selected \(search)")
    case let favorites as FavoritesVC:
      print("Selected \(favorites)")
    default:
      break
    }
  }
}
