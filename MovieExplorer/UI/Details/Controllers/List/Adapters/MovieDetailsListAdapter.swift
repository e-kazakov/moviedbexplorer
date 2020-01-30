//
//  MovieDetailsListAdapter.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/24/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsListAdapter {
  
  private let similarMoviesAdapter: MovieDetailsRelatedMoviesListAdapter
  private let similarMoviesController: ListController
  private let recommendedMoviesAdapter: MovieDetailsRelatedMoviesListAdapter
  private let recommendedMoviesController: ListController

  init(
    similarMoviesAdapter: MovieDetailsRelatedMoviesListAdapter,
    similarMoviesController: ListController,
    recommendedMoviesAdapter: MovieDetailsRelatedMoviesListAdapter,
    recommendedMoviesController: ListController
  ) {
    self.similarMoviesAdapter = similarMoviesAdapter
    self.similarMoviesController = similarMoviesController
    self.recommendedMoviesAdapter = recommendedMoviesAdapter
    self.recommendedMoviesController = recommendedMoviesController
  }
  
  func list(_ viewModel: MovieDetailsViewModel) -> List {
    let sections = [
      postersSection(viewModel.posters),
      productionInfoSection(viewModel),
      titleSection(viewModel.title),
      overviewSection(tagline: viewModel.tagline, overview: viewModel.overview),
      imagesSection(viewModel.images),
      castTitleSection(viewModel.cast),
      castSection(viewModel.cast),
      crewTitleSection(viewModel.crew),
      crewSection(viewModel.crew),
      relatedMoviesTitleSection("Recommended"),
      recommendedMoviesSection(viewModel.recommendedMovies),
      relatedMoviesTitleSection("Similar"),
      similarMoviesSection(viewModel.similarMovies),
    ]
    return List(sections: sections.compactMap({ $0 }))
  }
  
  private func postersSection(_ posters: [ImageViewModel]) -> ListSection {
    let listController = ListController()
    listController.list = MovieDetailsImagesListAdapter().postersList(images: posters)
    return ListSection([
      ListListItem(controller: listController, height: 420, reuseIdentifier: "posters")
    ])
  }
  
  private func titleSection(_ title: String) -> ListSection {
    var section = ListSection([LabelListItem(text: title, style: LabelCell.Style.movieDetailsTitleStyle)])
    section.inset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    return section
  }
  
  private func productionInfoSection(_ viewModel: MovieDetailsViewModel) -> ListSection {
    var items: [ListItem] = []
        
    items.append(MovieDetailsProductionInfoListItem(releaseYear: viewModel.releaseYear, duration: viewModel.duration))
    items.append(LabelListItem(text: viewModel.genres, style: LabelCell.Style.movieDetailsGenresStyle))
    
    var section = ListSection(items)
    section.minimumLineSpacing = 8
    section.minimumInteritemSpacing = 8
    section.inset = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
    return section
  }
  
  private func overviewSection(tagline: String?, overview: String?) -> ListSection? {
    var items: [ListItem] = []
    if let tagline = tagline {
      items.append(LabelListItem(text: tagline, style: LabelCell.Style.movieDetailsTaglineStyle))
    }
    if let overview = overview {
      items.append(LabelListItem(text: overview, style: LabelCell.Style.movieDetailsOverviewStyle))
    }
    
    guard !items.isEmpty else { return nil }
    
    var section = ListSection(items)
    section.minimumLineSpacing = 8
    section.minimumInteritemSpacing = 8
    section.inset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    return section
  }
  
  private func imagesSection(_ images: [ImageViewModel]) -> ListSection? {
    guard !images.isEmpty else { return nil }
    let listController = ListController()
    listController.list = MovieDetailsImagesListAdapter().backdropsList(images: images)
    var section = ListSection([
      ListListItem(controller: listController, height: 152, reuseIdentifier: "backdrops")
    ])
    section.inset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    return section
  }
  
  private func castTitleSection(_ cast: [MoviePersonellMemberViewModel]) -> ListSection? {
    return membersTitleSection(members: cast, title: "Cast")
  }
  
  private func castSection(_ cast: [MoviePersonellMemberViewModel]) -> ListSection? {
    membersSection(members: cast, identifier: "cast")
  }

  private func crewTitleSection(_ cast: [MoviePersonellMemberViewModel]) -> ListSection? {
    return membersTitleSection(members: cast, title: "Crew")
  }
  
  private func crewSection(_ crew: [MoviePersonellMemberViewModel]) -> ListSection? {
    membersSection(members: crew, identifier: "crew")
  }
  
  private func membersSection(members: [MoviePersonellMemberViewModel], identifier: String) -> ListSection? {
    guard !members.isEmpty else { return nil }
    let listController = ListController()
    listController.list = MovieDetailsMembersListAdapter().list(members)
    
    var section = ListSection([
      ListListItem(controller: listController, height: 240, reuseIdentifier: identifier)
    ])
    section.inset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
    return section
  }

  private func membersTitleSection(members: [MoviePersonellMemberViewModel], title: String) -> ListSection? {
    guard !members.isEmpty else { return nil }
    
    var section = ListSection([MovieDetailsSecondaryTitleListItem(title: title)])
    section.inset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    return section
  }
  
  private func relatedMoviesTitleSection(_ title: String) -> ListSection {
    var section = ListSection([MovieDetailsSecondaryTitleListItem(title: title)])
    section.inset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    return section
  }
  
  private func recommendedMoviesSection(_ movies: RelatedMoviesListViewModel) -> ListSection? {
    relatedMoviesSection(
      movies,
      adapter: recommendedMoviesAdapter,
      controller: recommendedMoviesController,
      identifier: "recommended"
    )
  }
  
  private func similarMoviesSection(_ movies: RelatedMoviesListViewModel) -> ListSection? {
    relatedMoviesSection(
      movies,
      adapter: similarMoviesAdapter,
      controller: similarMoviesController,
      identifier: "similar"
    )
  }
  
  private func relatedMoviesSection(
    _ movies: RelatedMoviesListViewModel,
    adapter: MovieDetailsRelatedMoviesListAdapter,
    controller listController: ListController,
    identifier: String
  ) -> ListSection? {
      
    movies.onChanged = { [weak listController, weak adapter] in
      guard let listController = listController, let adapter = adapter else { return }
      listController.list = adapter.list(movies)
      listController.isScrollable = true
    }

    listController.list = adapter.list(movies)
    listController.isScrollable = movies.status != .loading && movies.status != .failedToLoad
    
    var section = ListSection([
      ListListItem(controller: listController, height: 240, reuseIdentifier: identifier)
    ])
    section.inset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
    return section
  }
}
