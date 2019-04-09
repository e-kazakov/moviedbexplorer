//
//  MovieViewModel.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

protocol MovieViewModel {
  var title: String { get }
  var overview: String? { get }
  var releaseYear: String { get }
  var isFavorite: Bool { get }
  var image: RemoteImageViewModelProtocol? { get }
  
  func toggleFavorite()
}

class MovieViewModelImpl: MovieViewModel {

  let title: String
  let overview: String?
  let releaseYear: String
  let isFavorite: Bool
  let image: RemoteImageViewModelProtocol?
  
  private let movie: Movie
  private let apiClient: APIClient
  private let imageFetcher: ImageFetcher

  init(movie: Movie, api: APIClient, imageFetcher: ImageFetcher) {
    self.movie = movie
    self.apiClient = api
    self.imageFetcher = imageFetcher
    
    let releaseYear = movie.releaseDate.split(separator: "-").first.map(String.init) ?? ""
    title = movie.title
    overview = movie.overview
    self.releaseYear = releaseYear
    let url = movie.posterPath.map { api.posterURL(path: $0, size: .w780) }
    image = url.map { RemoteImageViewModel(url: $0, fetcher: imageFetcher) }
    isFavorite = false
  }
  
  func toggleFavorite() {
  }
}
