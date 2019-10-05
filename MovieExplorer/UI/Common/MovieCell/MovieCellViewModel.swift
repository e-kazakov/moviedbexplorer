//
//  MovieCellViewModel.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 4/10/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

protocol MovieCellViewModel {
  var title: String { get }
  var overview: String? { get }
  var releaseYear: String { get }
  var image: ImageViewModelProtocol? { get }
  
  func select()
}

class MovieCellViewModelImpl: MovieCellViewModel {
  
  let title: String
  let overview: String?
  let releaseYear: String
  let image: ImageViewModelProtocol?
  
  private let movie: Movie
  private let imageFetcher: ImageFetcher
  
  var onSelect: (() -> Void)?
  
  init(movie: Movie, imageFetcher: ImageFetcher) {
    self.movie = movie
    self.imageFetcher = imageFetcher
    
    let releaseYear = movie.releaseDate?.split(separator: "-").first.map(String.init) ?? "N/A"
    title = movie.title ?? ""
    overview = movie.overview
    self.releaseYear = releaseYear

    let placeholder = UIImage.mve.posterPlaceholder
    if let url = movie.posterPath.map({ imageFetcher.posterURL(path: $0, size: .w780) }) {
      image = RemoteImageViewModel(url: url, placeholder: placeholder, fetcher: imageFetcher)
    } else {
      image = StaticImageViewModel(image: placeholder)
    }
  }
  
  func select() {
    onSelect?()
  }
}

