//
//  Coordinator.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 05.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

protocol Coordinator: class {
  
  var isStarted: Bool { get }
  
  func start()
  
}
