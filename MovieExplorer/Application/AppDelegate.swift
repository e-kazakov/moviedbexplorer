//
//  AppDelegate.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

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

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Fixes dark spot artefact during push when navigation bar is translucent
    // and `hidesBottomBarWhenPushed` set to `true` on pushed controller.
    self.window?.backgroundColor = UIColor.white
    
    (self.window?.rootViewController as? MainTabVC)?.initialize(apiClient: apiClient, imageFetcher: imageFetcher)

    return true
  }

}
