//
//  FavoritesVC.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {

  var goToMovieDetails: ((Movie) -> Void)?
  
  private let viewModel: FavoritesViewModel

  private lazy var contentView = FavoritesView()
  private var collectionView: UICollectionView {
    return contentView.moviesListView
  }

  private let moviesCollectionController = ListController()
  private let moviesAdapter = MoviesAdapter()
  
  init (viewModel: FavoritesViewModel) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)

    configureNavigationItem()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    moviesCollectionController.collectionView = collectionView

    bind()
    update()
  }
  
  private func configureNavigationItem() {
    title = L10n.Favorites.navTitle
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
  
  private func bind() {
    bindOutputs()
  }
  
  private func bindOutputs() {
    viewModel.onChanged = { [weak self] in
      self?.update()
    }
    viewModel.onGoToDetails = { [weak self] movie in
      self?.goToMovieDetails?(movie)
    }
  }
  
  private func update() {
    moviesCollectionController.list = moviesAdapter.list(movies: viewModel.movies, status: .loaded)
    
    if viewModel.movies.isEmpty {
      contentView.showInitial()
    } else {
      contentView.showList()
    }
  }

}
