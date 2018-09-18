//
//  MovieViewModel.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieViewModel {
  
  let id: Int
  let title: String
  let overview: String?
  let releaseYear: String
  
  var image: UIImage? = nil {
    didSet {
      onChange?()
    }
  }
  
  var onChange: (() -> Void)?
  
  private let movie: Movie
  
  private let apiClient: APIClient
  
  private var imageTask: URLSessionTask?
  
  init(movie: Movie, api: APIClient) {
    self.movie = movie
    self.apiClient = api
    id = movie.id
    title = movie.title
    overview = movie.overview
    releaseYear = movie.releaseDate.split(separator: "-").first.map(String.init) ?? ""
  }
  
  func fetch() {
    guard imageTask == nil else { return }
    guard let posterPath = movie.posterPath else { return }
    let posterURL = apiClient.posterURL(path: posterPath, size: .w780)
    imageTask = URLSession.shared.dataTask(with: posterURL) { data, response, error in
      if let data = data {
        let image = UIImage(data: data)?.decoded()
        DispatchQueue.main.async { self.image = image }
      }
    }
    imageTask?.resume()
  }
  
  func cancel() {
    imageTask?.cancel()
    imageTask = nil
  }
}
