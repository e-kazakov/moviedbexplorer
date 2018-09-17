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

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    // Fixes dark spot artefact during push when navigation bar is translucent
    // and `hidesBottomBarWhenPushed` set to `true` on pushed controller.
    self.window?.backgroundColor = UIColor.white
    return true
  }

}
