//
//  AppCoordinator.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 05.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {
  
  private let window: UIWindow
  private let navigationController: UINavigationController = {
    let navVC = UINavigationController()
    navVC.setNavigationBarHidden(true, animated: false)
    return navVC
  }()
  
  private lazy var urlSession = createSession()
  
  private lazy var apiClient: APIClient = {
    let serverConfig = MovieDBServerConfig(
      apiBase: URL(string: "https://api.themoviedb.org/3/")!,
      imageBase: URL(string: "https://image.tmdb.org/t/p/")!,
      apiKey: "8ce5ac519ae011454741f33c416274e2"
    )
    return URLSessionAPIClient(serverConfig: serverConfig, urlSession: urlSession)
  }()
  
  private lazy var imageFetcher: ImageFetcher = {
    return URLSessionImageFetcher(session: urlSession)
  }()
  
  init(window: UIWindow) {
    self.window = window
  }
  
  override func start() {
    super.start()
    
    window.rootViewController = navigationController
    window.makeKeyAndVisible()

    startMainTabsFlow()
  }
  
  private func startMainTabsFlow() {
    let mainTabsCoordinator = MainTabsCoordinator(
      navigation: navigationController,
      apiClient: apiClient,
      imageFetcher: imageFetcher,
      favorites: TMDBFavoriteMovies(repository: JSONFavoriteMoviesRepository())
    )
    startSubflow(mainTabsCoordinator)
  }
  
}
