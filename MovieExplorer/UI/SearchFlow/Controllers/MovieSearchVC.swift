//
//  FirstViewController.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieSearchVC: UIViewController {

  var goToMovieDetails: ((Movie) -> Void)?
  
  private var viewModel: MovieSearchViewModel
  
  private let searchBar = UISearchBar()
  private lazy var contentView = MovieSearchView()
  private var moviesListView: UICollectionView {
    return contentView.moviesListView
  }
  
  private let moviesCollectionController = ListController()
  private let moviesAdapter = MoviesAdapter()
  private let recentSearchesCollectionController = ListController()
  private let recentSearchesAdapter = RecentSearchesListAdapter()
  
  private var isLoading: Bool? = false
  
  private let keyboardObserver = KeyboardObserver(notificationCenter: .default)
  
  init(viewModel: MovieSearchViewModel) {
    self.viewModel = viewModel

    super.init(nibName: nil, bundle: nil)
    
    configureNavigationItem()
    
    searchBar.delegate = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureNavigationItem() {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.titleView = searchBar
  }
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    configureKeyboardObserver()
    
    recentSearchesCollectionController.collectionView = contentView.recentSearchesListView
    moviesCollectionController.collectionView = contentView.moviesListView

    bind()
    update()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    keyboardObserver.startObserving()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    keyboardObserver.stopObserving()
  }
  
  private func configureKeyboardObserver() {
    keyboardObserver.onKeyboardWillShow = { [weak self] kbInfo in
      self?.contentView.recentSearchesListView.adjustContentInset(forKeyboard: kbInfo)
    }
    
    keyboardObserver.onKeyboardWillHide = { [weak self] in
      self?.contentView.recentSearchesListView.contentInset = .zero
    }
  }

  private func bind() {
    bindOutputs()
    bindInputs()
  }
  
  private func bindOutputs() {
    viewModel.onChanged = { [weak self] in
      self?.update()
    }
    viewModel.onGoToDetails = { [weak self] movie in
      self?.goToMovieDetails?(movie)
    }
  }
  
  private func bindInputs() {
    contentView.errorView.onRetry = viewModel.retry
    moviesCollectionController.onCloseToEnd = viewModel.loadNext
    moviesAdapter.onRetry = viewModel.retry
    
    recentSearchesAdapter.onSelect = { [weak self] query in
      guard let self = self else { return }
      
      self.searchBarEndEditing()
      
      self.viewModel.search(query: query)
      self.contentView.showList()
    }
  }
  
  private func update() {
    searchBar.text = viewModel.searchQuery

    updateLists()
    updateViewsVisibility()
  }
  
  func updateLists() {
    recentSearchesCollectionController.list = recentSearchesAdapter.list(from: viewModel.recentSearches)
    
    switch viewModel.status {
    case .loading:
      configureForLoading()
      
    case .loaded, .loadingNext, .failedToLoadNext:
      configureForLoaded()
      
    case .initial, .failedToLoad:
      break
    }
  }
  
  func updateViewsVisibility() {
    if searchBar.isFirstResponder {
      contentView.showLastSearches()
      return
    }

    switch viewModel.status {
    case .initial:
      contentView.showInitial()

    case .loading:
      contentView.showList()

    case .loaded, .loadingNext, .failedToLoadNext:
      if viewModel.movies.isEmpty {
        contentView.showEmpty()
      } else {
        contentView.showList()
      }

    case .failedToLoad:
      contentView.showError()
    }
  }
  
  private func configureForLoading() {
    moviesCollectionController.list = moviesAdapter.loadingList()
    
    if isLoading != true {
      isLoading = true
      moviesListView.scrollToTop()
      moviesListView.isUserInteractionEnabled = false
      moviesListView.mve.crossDissolveTransition { }
    }
  }
  
  private func configureForLoaded() {
    moviesCollectionController.list = moviesAdapter.list(movies: viewModel.movies, status: viewModel.status)
    
    if isLoading != false {
      isLoading = false
      moviesListView.scrollToTop()
      moviesListView.isUserInteractionEnabled = true
      moviesListView.mve.crossDissolveTransition { }
    }
  }
  
  private func searchBarBeginEditing() {
    searchBar.setShowsCancelButton(true, animated: true)
  }
  
  private func searchBarEndEditing() {
    searchBar.endEditing(true)
    searchBar.setShowsCancelButton(false, animated: true)
  }
}

extension MovieSearchVC: UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBarBeginEditing()
    
    contentView.recentSearchesListView.scrollToTop()
    contentView.showLastSearches()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let query = searchBar.text, !query.isEmpty {
      viewModel.search(query: query)
    } else {
      viewModel.cancel()
    }
    
    searchBarEndEditing()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBarEndEditing()
    update()
  }
}

extension UIScrollView {
  func scrollToTop() {
    contentOffset = CGPoint(x: 0, y: -adjustedContentInset.top)
  }
  
  func adjustContentInset(forKeyboard keyboardInfo: KeyboardInfo) {
    guard let window = self.window else { return }
    
    let kbFrame = convert(keyboardInfo.endFrame, from: window)
    let kbHeight = bounds.intersection(kbFrame).height
    
    guard kbHeight > 0 else { return }
    
    let bottomInset = kbHeight - safeAreaInsets.bottom
    contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
    scrollIndicatorInsets = contentInset
  }
}

#if DEBUG
import SwiftUI

struct MovieSearchVCPreview: UIViewControllerRepresentable {
  
  let vm: MovieSearchViewModel
  
  func makeUIViewController(context: Context) -> UINavigationController {
    return UINavigationController(rootViewController: MovieSearchVC(viewModel: vm))
  }

  func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
  }

}

struct MovieSearchVC_PreviewProvider: PreviewProvider {
  
  static var previews: some View {
    Group {
      createPreviews()
      .previewDisplayName("Light")
      
      createPreviews()
      .colorScheme(.dark)
      .previewDisplayName("Dark")
    }
  }
  
}

private func createPreviews() -> some View {
  Group {
    MovieSearchVCPreview(vm: makeInitialVM())
      .edgesIgnoringSafeArea([.top, .bottom])
    MovieSearchVCPreview(vm: makeEmptyVM())
      .edgesIgnoringSafeArea([.top, .bottom])
    MovieSearchVCPreview(vm: makeErrorVM())
      .edgesIgnoringSafeArea([.top, .bottom])
    MovieSearchVCPreview(vm: makeLoadingVM())
      .edgesIgnoringSafeArea([.top, .bottom])
    MovieSearchVCPreview(vm: makeResultVM())
      .edgesIgnoringSafeArea([.top, .bottom])
    MovieSearchVCPreview(vm: makeLoadingMoreVM())
      .edgesIgnoringSafeArea([.top, .bottom])
  }
}

struct MovieSearchPreviewViewModel: MovieSearchViewModel {
  var searchQuery: String?
  var status: MoviesListViewModelStatus
  var movies: [MovieCellViewModel]
  var recentSearches: [String]

  var onChanged: (() -> Void)? = nil
  var onGoToDetails: ((Movie) -> Void)? = nil
  
  func search(query: String) { }
  func cancel() { }
  func loadNext() { }
  func retry() { }
}

struct MovieCellPreviewViewModel: MovieCellViewModel {
  var title: String
  var overview: String?
  var releaseYear: String
  var image: ImageViewModel?

  func select() { }
}

private func makeInitialVM() -> MovieSearchViewModel {
  MovieSearchPreviewViewModel(searchQuery: nil,
                              status: .initial,
                              movies: [],
                              recentSearches: [])
}

private func makeEmptyVM() -> MovieSearchViewModel {
  MovieSearchPreviewViewModel(searchQuery: "Shmatrix",
                              status: .loaded,
                              movies: [],
                              recentSearches: ["Shmatrix"])
}

private func makeErrorVM() -> MovieSearchViewModel {
  MovieSearchPreviewViewModel(searchQuery: "Shmatrix",
                              status: .failedToLoad,
                              movies: [],
                              recentSearches: ["Shmatrix"])
}

private func makeLoadingVM() -> MovieSearchViewModel {
  MovieSearchPreviewViewModel(searchQuery: "Matrix",
                              status: .loading,
                              movies: [],
                              recentSearches: ["Avengers", "Matrix"])
}

private func makeResultVM() -> MovieSearchViewModel {
  MovieSearchPreviewViewModel(searchQuery: "Matrix",
                              status: .loaded,
                              movies: [makeMovieVM()],
                              recentSearches: ["Avengers", "Matrix"])
}

private func makeLoadingMoreVM() -> MovieSearchViewModel {
  MovieSearchPreviewViewModel(searchQuery: "Matrix",
                              status: .loadingNext,
                              movies: [makeMovieVM()],
                              recentSearches: ["Avengers", "Matrix"])
}

private func makeMovieVM() -> MovieCellPreviewViewModel {
  MovieCellPreviewViewModel(title: "Matrix",
                            overview: "Set in the 22nd century, The Matrix tells the story of a computer hacker who joins a group of underground insurgents fighting the vast and powerful computers who now rule the earth.",
                            releaseYear: "1999",
                            image: StaticImageViewModel(image: UIImage(named: "poster.matrix")!))
}

#endif
