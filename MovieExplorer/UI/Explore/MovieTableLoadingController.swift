//
//  MovieTableLoadingController.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 5/30/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieTableLoadingController: NSObject, UITableViewDataSource, UITableViewDelegate {
  
  var tableView: UITableView? = nil {
    didSet {
      configureTableView()
    }
  }

  private let loadingCellsCount = 10
  
  private func configureTableView() {
    guard let tableView = tableView else { return }
    
    tableView.register(MovieSkeletonCell.self,
                       forCellReuseIdentifier: MovieSkeletonCell.defaultReuseIdentifier)
    tableView.rowHeight = MovieSkeletonCell.preferredHeight
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  // MARK: DataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return loadingCellsCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let reusedCell = tableView.dequeueReusableCell(withIdentifier: MovieSkeletonCell.defaultReuseIdentifier) {
      
      guard let reusedMovieCell = reusedCell as? MovieSkeletonCell else {
        fatalError("Unexpected type of reused cell. Expecting \(MovieSkeletonCell.self), got \(type(of: reusedCell))")
      }
      
      return reusedMovieCell
    } else {
      return MovieSkeletonCell(
        style: UITableViewCell.CellStyle.default,
        reuseIdentifier: MovieSkeletonCell.defaultReuseIdentifier)
    }
  }
  
  // MARK: Delegate

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let skeletonCell = cell as? MovieSkeletonCell else {
      return
    }
    skeletonCell.startAnimation()
  }
}
