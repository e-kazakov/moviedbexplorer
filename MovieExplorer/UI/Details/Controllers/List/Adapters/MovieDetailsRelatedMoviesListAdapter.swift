//
//  RelatedMoviesListAdapter.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 1/5/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import UIKit

private typealias RelatedMovieSkeletonListItem = SimpleListItem<MovieDetailsRelatedMovieSkeletonCell>
private typealias RelatedMovieSkeletonSupplementaryItem = SimpleListSupplementaryItem<MovieDetailsRelatedMovieSkeletonCell>

class MovieDetailsRelatedMoviesListAdapter {

  var onRetry: (() -> Void)?
  var onGoToDetails: ((Movie) -> Void)?
  
  func list(_ viewModel: RelatedMoviesListViewModel) -> List {
    switch viewModel.status {
    case .initial: return .empty
    case .loading: return loadingList()
    case .loaded: return loadedList(movies: viewModel.movies, nextStatus: .loaded)
    case .loadingNext: return loadedList(movies: viewModel.movies, nextStatus: .loading)
    case .failedToLoad: return errorList()
    case .failedToLoadNext: return loadedList(movies: viewModel.movies, nextStatus: .failed)
    }
  }
  
  private func loadingList() -> List {
    var section = ListSection((0..<10).generate(RelatedMovieSkeletonListItem.init))
    section.minimumInteritemSpacing = 12
    section.minimumLineSpacing = 12
    section.inset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
    return List(sections: [section])
  }
  
  private func errorList() -> List {
    let item = MovieDetailsRelatedMoviesFailedListItem()
    item.onRetry = { [weak self] in self?.onRetry?() }
    return List.single(item)
  }
  
  private func emptyList() -> List {
    List.single(
      MovieDetailsRelatedMoviesEmptyListItem()
    )
  }
  
  private enum NextStatus {
    case loading, loaded, failed
  }
  
  private func loadedList(movies: [RelatedMovieCellViewModel], nextStatus: NextStatus) -> List {
    guard !movies.isEmpty else { return emptyList() }
    
    var section = ListSection(
      header: nil,
      items: movies.map { movie in
        let item = MovieDetailsRelatedMovieListItem(movie: movie)
        item.onSelect = movie.select
        return item
      },
      footer: footer(nextStatus)
    )
    section.minimumInteritemSpacing = 12
    section.minimumLineSpacing = 12
    section.inset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)

    return List(sections: [section])
  }
  
  private func footer(_ status: NextStatus) -> ListSupplementaryItem? {
    switch status {
    case .loaded:
      return nil
    
    case .loading:
      return RelatedMovieSkeletonSupplementaryItem()
    
    case .failed:
      let failedFooter = MovieDetailsRelatedMoviesFailedSupplementaryItem()
      failedFooter.onRetry = { [weak self] in self?.onRetry?() }
      return failedFooter
    }
  }
}
