//
//  L10n.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 2/8/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import Foundation

enum L10n {

  enum Common {
    enum MoviesList {
      static let reloadButton = "movies_error_retry_button".localized
      static let failedTitle = "movies_failed_title".localized
      static let failedMessage = "movies_failed_message".localized
      static let moreFailedMessage = "movies_more_failed_message".localized
    }
  }
  
  enum Tabs {
    static let explore = "tab_explore".localized
    static let favorites = "tab_favorites".localized
    static let search = "tab_search".localized
  }
  
  enum Explore {
    static let navTitle = "explore_nav_title".localized
    static let failedTitle = "explore_failed_title".localized
    static let failedMessage = "explore_failed_message".localized
    static let failedRetryButton = "explore_failed_retry_button".localized
  }
  
  enum Favorites {
    static let navTitle = "favorites_nav_title".localized
    static let emptyMessage = "favorites_empty_message".localized
  }
  
  enum Search {
    static let initialMessage = "search_initial_message".localized
    static let emptyMessage = "search_empty_message".localized
    static let failedTitle = "search_failed_title".localized
    static let failedMessage = "search_failed_message".localized
    static let failedRetryButton = "search_failed_retry_button".localized
  }
  
  enum Details {
    static let failedTitle = "details_failed_title".localized
    static let sectionCastTitle = "details_section_cast_title".localized
    static let sectionCrewTitle = "details_section_crew_title".localized
    static let sectionRecommendedTitle = "details_section_recommended_title".localized
    static let sectionSimilarTitle = "details_section_similar_title".localized
    static let relatedMoviesEmptyMessage = "details_related_movies_empty_message".localized
    static let relatedMoviesFailedMessage = "details_related_movies_failed_message".localized
  }
}
