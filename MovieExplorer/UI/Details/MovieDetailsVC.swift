//
//  MovieDeatilsVC.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsVC: UIViewController {
  
  private let viewModel: MovieViewModel

  private let detailsView = MovieDetailsView()

  init(viewModel: MovieViewModel) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)
    
    configureNavigationItem()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    bind()
    load()
    update()
  }
  
  private func configureNavigationItem() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.tmdb.starO,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(onToggleFavorite))
  }
  
  private func setupViews() {
    self.view.backgroundColor = .appBackground
    
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    detailsView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(scrollView)
    scrollView.addSubview(detailsView)
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),

      detailsView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      detailsView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
      detailsView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
      detailsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      detailsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
    ])
  }

  private func bind() {
    bindOutputs()
    bindInputs()
  }
  
  private func bindOutputs() {
    viewModel.onChanged = { [weak self] in
      self?.update()
    }
  }
  
  private func bindInputs() {
  }
  
  private func update() {
    title = viewModel.title
    detailsView.nameLabel.text = viewModel.title
    detailsView.overviewLabel.text = viewModel.overview
    detailsView.releaseYearLabel.text = viewModel.releaseYear
    
    detailsView.posterImageView.tmdb.setImage(viewModel.image)
    
    let favButton = UIBarButtonItem(
      image: viewModel.isFavorite ? UIImage.tmdb.starFilled : UIImage.tmdb.starO,
      style: .plain,
      target: self,
      action: #selector(onToggleFavorite)
    )
    navigationItem.setRightBarButton(favButton, animated: true)
  }
  
  private func load() {
    viewModel.image?.load()
  }
  
  // MARK: Actions
  
  @objc
  private func onToggleFavorite() {
    viewModel.toggleFavorite()
  }
}
