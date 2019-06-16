//
//  MovieDeatilsVC.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsVC: UIViewController {
  
  private let detailsView = MovieDetailsView()
  
  var viewModel: MovieViewModel? {
    didSet {
      if isViewLoaded {
        bind()
      }
    }
  }

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
  }
  
  private func configureNavigationItem() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.tmdb.starO,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(onToggleFavorite))
  }
  
  private func setupViews() {
    self.view.backgroundColor = .white
    
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
    guard let viewModel = viewModel else { return }
    
    title = viewModel.title
    detailsView.nameLabel.text = viewModel.title
    detailsView.overviewLabel.text = viewModel.overview
    detailsView.releaseYearLabel.text = viewModel.releaseYear
    
    detailsView.posterImageView.tmdb.setImage(remote: viewModel.image)
  }
  
  private func load() {
    viewModel?.image?.load()
  }
  
  // MARK: Actions
  
  private var isStarred = false
  
  @objc
  private func onToggleFavorite() {
    isStarred.toggle()
    
    let favButton = UIBarButtonItem(
      image: isStarred ? UIImage.tmdb.starFilled : UIImage.tmdb.starO,
      style: .plain,
      target: self, action: #selector(onToggleFavorite)
    )
    navigationItem.setRightBarButton(favButton, animated: true)
  }
}
