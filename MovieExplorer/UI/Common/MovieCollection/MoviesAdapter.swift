//
//  MoviesAdapter.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/19/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

private typealias MovieSkeletonListItem = SimpleListItem<MovieSkeletonCell>
private typealias MovieSkeletonSupplementaryItem = SimpleListSupplementaryItem<MovieSkeletonCell>

class MoviesAdapter {
  
  var onRetry: (() -> Void)?
 
  func loadingList() -> List {
    List(sections: [
      ListSection((0..<10).generate(MovieSkeletonListItem.init))
    ])
  }
  
  func list(movies: [MovieCellViewModel], status: MoviesListViewModelStatus) -> List {
    List(sections: [
      ListSection(header: nil, items: movies.map(MovieListItem.init), footer: footer(status))
    ])
  }
    
  private func footer(_ status: MoviesListViewModelStatus) -> ListSupplementaryItem? {
    switch status {
    case .loadingNext:
      return MovieSkeletonSupplementaryItem()
    
    case .failedToLoadNext:
      let failedFooter = MovieLoadingFailedSupplementaryItem()
      failedFooter.onRetry = { [weak self] in self?.onRetry?() }
      return failedFooter
    
    default:
      return nil
    }
  }
  
}
