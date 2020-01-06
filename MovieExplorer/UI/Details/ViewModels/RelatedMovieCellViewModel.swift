//
//  RelatedMovieViewModel.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 1/5/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import UIKit

protocol RelatedMovieCellViewModel: class {
  var title: String { get }
  var poster: ImageViewModel? { get }
  
  func select()
}

class RelatedMovieCellViewModelImpl: RelatedMovieCellViewModel {
  
  let title: String
  let poster: ImageViewModel?

  var onSelect: (() -> Void)?

  private let movie: Movie
  private let imageFetcher: ImageFetcher

  init(movie: Movie, imageFetcher: ImageFetcher) {
    self.movie = movie
    self.imageFetcher = imageFetcher
    
    title = movie.title ?? ""
    let placeholder = UIImage.mve.posterPlaceholder
    if let url = movie.posterPath.map({ imageFetcher.posterURL(path: $0, size: .w500) }) {
      poster = RemoteImageViewModel(url: url, placeholder: placeholder, fetcher: imageFetcher)
    } else {
      poster = StaticImageViewModel(image: placeholder)
    }
  }
  
  func select() {
    onSelect?()
  }

}
