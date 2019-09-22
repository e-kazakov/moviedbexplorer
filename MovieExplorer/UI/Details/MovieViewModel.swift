//
//  MovieViewModel.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

protocol MovieViewModel: class {
  var title: String { get }
  var overview: String? { get }
  var releaseYear: String { get }
  var isFavorite: Bool { get }
  var image: ImageViewModelProtocol? { get }
  
  var onChanged: (() -> Void)? { get set }

  func toggleFavorite()
}

class MovieViewModelImpl: MovieViewModel {

  let title: String
  let overview: String?
  let releaseYear: String
  private(set) var isFavorite: Bool = false
  let image: ImageViewModelProtocol?
  
  var onChanged: (() -> Void)?

  private let movie: Movie
  private let imageFetcher: ImageFetcher
  private let favorites: FavoriteMovies
  private var disposable: Disposable?

  deinit {
    disposable?.dispose()
  }
  
  init(movie: Movie, favorites: FavoriteMovies, imageFetcher: ImageFetcher) {
    self.movie = movie
    self.imageFetcher = imageFetcher
    self.favorites = favorites
    
    let releaseYear = movie.releaseDate?.split(separator: "-").first.map(String.init) ?? "N/A"
    title = movie.title ?? ""
    overview = movie.overview
    self.releaseYear = releaseYear
    
    let placeholder = UIImage.tmdb.posterPlaceholder
    if let url = movie.posterPath.map({ imageFetcher.posterURL(path: $0, size: .w780) }) {
      image = RemoteImageViewModel(url: url, placeholder: placeholder, fetcher: imageFetcher)
    } else {
      image = StaticImageViewModel(image: placeholder)
    }

    update(favorites.store.state)
    
    disposable = favorites.store.observe { [weak self] favoritesState in
      self?.update(favoritesState)
    }
  }
  
  func toggleFavorite() {
    favorites.toggleFavorite(movie: movie)
  }
  
  private func update(_ favorites: FavoriteMoviesState) {
    isFavorite = favorites.isFavorite(movie)
    onChanged?()
  }
}
