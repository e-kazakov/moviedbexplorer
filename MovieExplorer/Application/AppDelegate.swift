//
//  AppDelegate.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  private var coordinator: AppCoordinator?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    // Fixes dark spot artefact during push when navigation bar is translucent
    // and `hidesBottomBarWhenPushed` set to `true` on pushed controller.
    window.backgroundColor = .systemBackground

    let appCoordinator = AppCoordinator(window: window)

    self.window = window
    self.coordinator = appCoordinator
    
    appCoordinator.start()

    return true
  }
  
}
