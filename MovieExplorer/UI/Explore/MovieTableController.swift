//
//  MovieTableController.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieTableController: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching, UITableViewDelegate {
  
  var onCloseToEnd: (() -> Void)?
  
  let screensOfContentToBeClose = 1 as CGFloat
  
  var tableView: UITableView? = nil {
    didSet {
      configureTableView()
    }
  }
  
  var movies: [MovieCellViewModel] = [] {
    didSet {
      if movies.count != oldValue.count {
        tableView?.reloadData()
      }
    }
  }
  
  private let apiClient: APIClient
  
  init(api: APIClient) {
    apiClient = api
  }
  
  private func configureTableView() {
    guard let tableView = tableView else { return }
    
    tableView.register(MovieCell.nib, forCellReuseIdentifier: MovieCell.defaultReuseIdentifier)
    tableView.rowHeight = MovieCell.preferredHeight
    
    tableView.delegate = self
    tableView.prefetchDataSource = self
    tableView.dataSource = self
  }
  
  // MARK: DataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let movie = movies[indexPath.row]
    let movieCell = self.movieCell(tableView: tableView, at: indexPath)
    
    movieCell.configure(with: movie)
    
    return movieCell
  }
  
  private func movieCell(tableView: UITableView, at indexPath: IndexPath) -> MovieCell {
    if let reusedCell = tableView.dequeueReusableCell(withIdentifier: MovieCell.defaultReuseIdentifier) {
      
      guard let reusedMovieCell = reusedCell as? MovieCell else {
        fatalError("Unexpected type of reused cell. Expecting \(MovieCell.self), got \(type(of: reusedCell))")
      }
      
      return reusedMovieCell
    } else {
      return MovieCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: MovieCell.defaultReuseIdentifier)
    }
  }
  
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    indexPaths
      .map { movies[$0.row] }
      .forEach { $0.image?.load() }
  }
  
  // MARK: Delegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    movies[indexPath.row].select()
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if isCloseToEnd {
      onCloseToEnd?()
    }
  }
  
  private var isCloseToEnd: Bool {
    return distanceToEnd <= distanceToEndThreshold
  }
  
  private var distanceToEndThreshold: CGFloat {
    guard let tableView = tableView else { return 0 }
    
    return tableView.bounds.height * screensOfContentToBeClose
  }
  
  private var distanceToEnd: CGFloat {
    guard let tableView = tableView else { return 0 }

    return tableView.contentSize.height - tableView.bounds.size.height - tableView.contentOffset.y
  }
}
