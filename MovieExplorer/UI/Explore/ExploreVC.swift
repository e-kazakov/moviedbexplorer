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
  
  private var moviesList: MoviesListViewModel!
  private var apiClient: APIClient!
  
  private var modelSubscriptionToken: SubscriptionToken?
  
  private var isInitialized = false
  
  private let detailsSequeIdentifier = "explore_details"
  
  deinit {
    modelSubscriptionToken?.dispose()
  }
  
  func initialize(moviesList: MoviesListViewModel, apiClient: APIClient) {
    guard !isInitialized else { return }
    
    self.moviesList = moviesList
    self.apiClient = apiClient
    
    isInitialized = true
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    configureNavigationItem()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    configureNavigationItem()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard isInitialized else {
      fatalError("Must be initialized.")
    }
    
    configureMoviesTableView()
    
    bind()
    moviesList.loadNext()
  }
  
  private func configureNavigationItem() {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
  
  private func configureMoviesTableView() {
    movieTableController.tableView = tableView
    movieTableController.onCloseToEnd = { [weak self] in
      self?.moviesList.loadNext()
    }
  }
  
  private func bind() {
    moviesList.onChanged = { [weak self] in
      self?.update()
    }
    moviesList.onGoToDetails = { [weak self] movie in
      self?.goToDetails(movie)
    }
  }
  
  private func update() {
    movieTableController.movies = moviesList.movies
    
    switch moviesList.status {
    case .initial: break
    case .loading: showLoadingIndicator()
    case .loaded: hideLoadingIndicator()
    case .loadingNext: break
    case .failedToLoad: hideLoadingIndicator()
    case .failedToLoadNext: break
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
      detailsVC.viewModel = MovieViewModelImpl(movie: movie, api: apiClient)
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
  
  private func goToDetails(_ movie: Movie) {
    self.performSegue(withIdentifier: detailsSequeIdentifier, sender: movie)
  }
}
