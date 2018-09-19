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
  
  var tableView: UITableView? = nil {
    didSet {
      configureTableView()
    }
  }
  
  var movies: [MovieViewModel] = [] {
    didSet {
      tableView?.reloadData()
    }
  }
  
  private let apiClient: APIClient
  
  init(api: APIClient) {
    apiClient = api
  }
  
  private func configureTableView() {
    guard let tableView = tableView else { return }
    
    tableView.register(MovieCell.nib, forCellReuseIdentifier: MovieCell.defaultReuseIdentifier)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 198
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.prefetchDataSource = self
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
        fatalError("Unexpected type of rused cell. Expecting \(MovieCell.self), got \(type(of: reusedCell))")
      }
      
      return reusedMovieCell
    } else {
      return MovieCell(style: UITableViewCellStyle.default, reuseIdentifier: MovieCell.defaultReuseIdentifier)
    }
  }
  
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    indexPaths
      .map { movies[$0.row] }
      .forEach { $0.image?.load() }
  }
  
  func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    indexPaths
      .map { movies[$0.row] }
      .forEach { $0.image?.cancel() }
  }
  
  // MARK: Delegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    movies[indexPath.row].select()
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let threshold = scrollView.bounds.height * 3
    let distanceToEnd = scrollView.contentSize.height - scrollView.bounds.size.height - scrollView.contentOffset.y
    if distanceToEnd <= threshold {
      onCloseToEnd?()
    }
  }
}
