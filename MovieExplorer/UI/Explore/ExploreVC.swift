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
      self?.movieTableController.movies = state.movies
    }
    
    moviesList.loadNext()
  }
  
  private func configureMoviesTableView() {
    movieTableController.tableView = tableView
    movieTableController.onCloseToEnd = { [weak self] in
      self?.moviesList.loadNext()
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let bottomContentInset = view.safeAreaInsets.bottom + additionalSafeAreaInsets.bottom
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomContentInset, right: 0)
  }

}
