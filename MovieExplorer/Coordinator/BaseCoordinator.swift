//
//  BaseCoordinator.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 05.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

class BaseCoordinator: Coordinator {
  
  private(set) var isStarted: Bool = false
  
  private var subcoordinators: [Coordinator] = []
  
  func start() {
    isStarted = true
  }
  
  func addSubcoordinator(_ subcoordinator: Coordinator) {
    let added = subcoordinators.contains { $0 === subcoordinator }
    guard !added else { return }
    
    subcoordinators.append(subcoordinator)
  }
  
  func removeSubcoordinator(_ subcoordinator: Coordinator) {
    subcoordinators.removeAll { $0 === subcoordinator }
  }
  
}

extension BaseCoordinator {

  func startSubflow(_ coordinator: Coordinator) {
    addSubcoordinator(coordinator)
    coordinator.start()
  }
  
}
