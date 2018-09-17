//
//  SecondViewController.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class ExploreVC: UIViewController {

  @IBOutlet private var tableView: UITableView!
  @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
  
  private lazy var movieTableController = MovieTableController(api: apiClient)
  
  private lazy var apiClient: APIClient = {
    let serverConfig = MovieDBServerConfig(
      apiBase: URL(string: "https://api.themoviedb.org/3/")!,
      imageBase: URL(string: "https://image.tmdb.org/t/p/")!,
      apiKey: "8ce5ac519ae011454741f33c416274e2"
    )
    return URLSessionAPIClient(serverConfig: serverConfig, urlSession: URLSession.shared)
  }()
  
  private lazy var moviesList: MoviesList = TMDBMoviesList(api: apiClient)
  
  private var modelSubscriptionToken: SubscriptionToken?
  
  deinit {
    modelSubscriptionToken?.dispose()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureMoviesTableView()
    
    modelSubscriptionToken = moviesList.store.observe(on: DispatchQueue.main) { [weak self] state in
      self?.update(with: state)
    }
    
    moviesList.loadNext()
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
  
  private func configureMoviesTableView() {
    movieTableController.tableView = tableView
    movieTableController.onCloseToEnd = { [weak self] in
      self?.moviesList.loadNext()
    }
    movieTableController.onSelect = { [weak self] movie in
      self?.goToDetails(movie)
    }
  }

  private func update(with newState: MoviesListState) {
    movieTableController.movies = newState.movies
    
    let loadingFirstPage = newState.status.isLoading && newState.movies.isEmpty
    if loadingFirstPage {
      showLoadingIndicator()
    } else {
      hideLoadingIndicator()
    }
  }
  
  private func showLoadingIndicator() {
    tableView.isHidden = true
    loadingIndicator.startAnimating()
  }
  
  private func hideLoadingIndicator() {
    tableView.isHidden = false
    loadingIndicator.stopAnimating()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "explore_details" {
      guard let detailsVC = segue.destination as? MovieDetailsVC, let movie = sender as? Movie else {
        fatalError("Unexpected destination view controller.")
      }
      detailsVC.viewModel = MovieViewModel(movie: movie, api: apiClient)
      detailsVC.viewModel?.fetch()
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
  
  private func goToDetails(_ movie: Movie) {
    self.performSegue(withIdentifier: "explore_details", sender: movie)
  }
}
