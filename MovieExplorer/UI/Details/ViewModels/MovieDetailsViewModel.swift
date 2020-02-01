//
//  MovieViewModel.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

enum MovieDetailsViewStatus {
  case initial
  case loading
  case loaded
  case error
}

protocol MovieDetailsViewModel: class {
  var status: MovieDetailsViewStatus { get }
  
  var title: String { get }
  var tagline: String? { get }
  var overview: String? { get }
  var releaseYear: String { get }
  var duration: String { get }
  var isFavorite: Bool { get }
  var posters: [ImageViewModel] { get }
  var images: [ImageViewModel] { get }
  var genres: String { get }
  
  var cast: [MoviePersonellMemberViewModel] { get }
  var crew: [MoviePersonellMemberViewModel] { get }
  
  var similarMovies: RelatedMoviesListViewModel { get }
  var recommendedMovies: RelatedMoviesListViewModel { get }

  var onChanged: (() -> Void)? { get set }

  func load()
  func toggleFavorite()
}

class MovieDetailsViewModelImpl: MovieDetailsViewModel {

  private(set) var status: MovieDetailsViewStatus = .initial
  private(set) var title: String = ""
  private(set) var tagline: String? = nil
  private(set) var overview: String? = nil
  private(set) var releaseYear: String = ""
  private(set) var duration: String = ""
  private(set) var isFavorite: Bool = false
  private(set) var posters: [ImageViewModel] = []
  private(set) var images: [ImageViewModel] = []
  private(set) var genres: String = ""
  private(set) var cast: [MoviePersonellMemberViewModel] = []
  private(set) var crew: [MoviePersonellMemberViewModel] = []
  
  let similarMovies: RelatedMoviesListViewModel
  let recommendedMovies: RelatedMoviesListViewModel

  var onChanged: (() -> Void)?

  private let movie: Movie
  private let movieDetailsService: MovieDetailsAPIService
  private let imageFetcher: ImageFetcher
  private let favorites: FavoriteMovies
  private var disposable: Disposable?

  deinit {
    disposable?.dispose()
  }
  
  init(
    movie: Movie,
    movieDetailsService: MovieDetailsAPIService,
    favorites: FavoriteMovies,
    imageFetcher: ImageFetcher
  ) {
    self.movie = movie
    self.movieDetailsService = movieDetailsService
    self.imageFetcher = imageFetcher
    self.favorites = favorites
    self.similarMovies = RelatedMoviesListViewModelImpl(
      moviesList: TMDBMoviesList(service: SimilarMoviesLoader(moviedId: movie.id, service: movieDetailsService)),
      imageFetcher: imageFetcher
    )
    self.recommendedMovies = RelatedMoviesListViewModelImpl(
      moviesList: TMDBMoviesList(service: RecommendedMoviesLoader(moviedId: movie.id, service: movieDetailsService)),
      imageFetcher: imageFetcher
    )
    
    title = movie.title ?? ""
    overview = movie.overview?.emptyAsNil
    releaseYear = movie.releaseDate?.split(separator: "-").first.map(String.init) ?? "N/A"

    update(favorites.store.state)
    disposable = favorites.store.observe { [weak self] favoritesState in
      self?.update(favoritesState)
    }
  }
  
  func load() {
    guard status != .loading else { return }
    
    status = .loading

    movieDetailsService.details(id: movie.id) { [weak self] detailsResult in
      DispatchQueue.main.async {
        self?.update(detailsResult)
      }
    }
    
    onChanged?()
  }
  
  func toggleFavorite() {
    favorites.toggleFavorite(movie: movie)
  }
  
  private func update(_ detailsResult: Result<MovieDetails, APIError>) {
    switch detailsResult {
    case .success(let details):
      status = .loaded
      update(details)
      
    case .failure:
      status = .error
    }

    onChanged?()
  }
  
  private func update(_ details: MovieDetails) {
    title = details.title ?? ""
    tagline = details.tagline?.emptyAsNil
    overview = details.overview?.emptyAsNil
    releaseYear = details.releaseDate?.split(separator: "-").first.map(String.init) ?? "N/A"
    duration = details.runtime.map({ "\($0)min" }) ?? ""
    genres = details.genres.map({ $0.name }).joined(separator: ", ")

    let placeholder = UIImage.mve.posterPlaceholder
    
    var postersURLs = details.images.posters
      .map { imageFetcher.posterURL(path: $0.path, size: .w780) }
    
    if let mainPosterURL = details.posterPath.map({ imageFetcher.posterURL(path: $0, size: .w780) }) {
      postersURLs.remove(mainPosterURL)
      postersURLs.insert(mainPosterURL, at: 0)
    }

    if postersURLs.isEmpty {
      posters = [ StaticImageViewModel(image: placeholder) ]
    } else {
      posters = postersURLs
        .map { RemoteImageViewModel(url: $0, placeholder: placeholder, fetcher: imageFetcher) }
    }
    
    crew = details.credits.crew.map(personellViewModel)
    cast = details.credits.cast.map(personellViewModel)

    images = details.images.backdrops
      .map { imageFetcher.posterURL(path: $0.path, size: .w780) }
      .map { RemoteImageViewModel(url: $0, placeholder: placeholder, fetcher: imageFetcher) }
  }
  
  private func update(_ favorites: FavoriteMoviesState) {
    isFavorite = favorites.isFavorite(id: movie.id)
    onChanged?()
  }

  private func photoViewModel(for member: MovieDetailsPersonellMember) -> ImageViewModel? {
    guard let photoPath = member.profilePhotoPath else { return nil }
    
    let photoURL = imageFetcher.posterURL(path: photoPath, size: .w500)
    return RemoteImageViewModel(url: photoURL, fetcher: imageFetcher)
  }

  private func personellViewModel(for member: MovieDetailsPersonellMember) -> MoviePersonellMemberViewModel {
    let profilePhotoViewModel = photoViewModel(for: member)
    return MoviePersonellMemberViewModelImpl(
      name: member.name,
      occupation: member.occupation,
      photo: profilePhotoViewModel,
      initials: member.name.initials
    )
  }
}

private extension String {
  var initials: String {
    let namePartSeparator = CharacterSet.whitespaces.union(CharacterSet(charactersIn: "-"))
    let nameParts = components(separatedBy: namePartSeparator)
    return nameParts
      .map({ $0.uppercased() })
      .map({ $0.prefix(1) })
      .joined()
  }
}
