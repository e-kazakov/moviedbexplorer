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
  
  var movies: [Movie] = [] {
    didSet {
      let viewModelsById = moviesVM.reduce(into: [Int: MovieViewModel]()) { dict, viewModel in
        dict[viewModel.id] = viewModel
      }
      moviesVM = movies.map { viewModelsById[$0.id] ?? MovieViewModel(movie: $0, api: apiClient) }
    }
  }
  
  private var moviesVM: [MovieViewModel] = [] {
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
    return moviesVM.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let movie = moviesVM[indexPath.row]
    let movieCell = self.movieCell(tableView: tableView, at: indexPath)
    
    movieCell.configure(with: movie)
    movie.fetch()
    
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
      .map { moviesVM[$0.row] }
      .forEach { $0.fetch() }
  }
  
  func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    indexPaths
      .map { moviesVM[$0.row] }
      .forEach { $0.cancel() }
  }
  
  // MARK: Delegate

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let threshold = scrollView.bounds.height * 3
    let distanceToEnd = scrollView.contentSize.height - scrollView.bounds.size.height - scrollView.contentOffset.y
    if distanceToEnd <= threshold {
      onCloseToEnd?()
    }
  }
}
