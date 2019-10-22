//
//  AppCoordinator.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 05.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

typealias ImageCache = NSCache<NSURL, UIImage>

private func createSession() -> URLSessionProtocol {
  let config = URLSessionConfiguration.default
  config.urlCache = createURLSessionCache()
  return URLSession(configuration: config)
}

private func createURLSessionCache() -> URLCache {
  let mem = 50 * 1024 * 1024
  let disk = 500 * 1024 * 1024
  return URLCache(memoryCapacity: mem, diskCapacity: disk, diskPath: "urlcache")
}

private func createImageCache() -> ImageCache {
  let cache = ImageCache()
  cache.countLimit = 200
  return cache
}

class AppCoordinator: BaseCoordinator {
  
  private let window: UIWindow
  private let navigationController: UINavigationController = {
    let navVC = UINavigationController()
    navVC.setNavigationBarHidden(true, animated: false)
    return navVC
  }()
  
  private lazy var urlSession = createSession()

  private let serverConfig = MovieDBServerConfig(
    apiBase: URL(string: "https://api.themoviedb.org/")!,
    imageBase: URL(string: "https://image.tmdb.org/t/p/")!,
    apiKey: "8ce5ac519ae011454741f33c416274e2"
  )

  private lazy var apiClient = URLSessionAPIClient(serverConfig: serverConfig, urlSession: urlSession)
  
  private lazy var apiClientModern = URLSessionAPIClient(serverConfig: serverConfig, urlSession: urlSession)
  
  private lazy var imageFetcher = URLSessionImageFetcher(serverConfig: serverConfig, urlSession: urlSession, cache: imageCache)
  private lazy var imageCache = createImageCache()
  
  init(window: UIWindow) {
    self.window = window

    super.init()
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(memoryWarning),
                                           name: UIApplication.didReceiveMemoryWarningNotification,
                                           object: nil)
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
      apiClient: apiClientModern,
      imageFetcher: imageFetcher,
      favorites: TMDBFavoriteMovies(repository: JSONFavoriteMoviesRepository())
    )
    startSubflow(mainTabsCoordinator)
  }
  
  @objc
  private func memoryWarning() {
    debugPrint("Memory warning")
    imageCache.removeAllObjects()
  }  
}
