//
//  main.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 26.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

private var isUnitTesting: Bool {
  return ProcessInfo.processInfo.environment["UNITTEST"] == "1"
}

let appDelegateClass = isUnitTesting
  ? NSStringFromClass(TestAppDelegate.self)
  : NSStringFromClass(AppDelegate.self)

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, appDelegateClass)
