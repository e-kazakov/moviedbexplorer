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
  
  private var moviesList: MoviesList!
  private var apiClient: APIClient!
  
  private var modelSubscriptionToken: SubscriptionToken?
  
  private var isInitialized = false
  
  private let detailsSequeIdentifier = "explore_details"
  
  deinit {
    modelSubscriptionToken?.dispose()
  }
  
  func initialize(moviesList: MoviesList, apiClient: APIClient) {
    guard !isInitialized else { return }
    
    self.moviesList = moviesList
    self.apiClient = apiClient
    
    isInitialized = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard isInitialized else {
      fatalError("Must be initialized.")
    }
    
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
    if segue.identifier == detailsSequeIdentifier {
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
    self.performSegue(withIdentifier: detailsSequeIdentifier, sender: movie)
  }
}
