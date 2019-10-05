//
//  MainTabVC.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MainTabVC: UITabBarController, UITabBarControllerDelegate {

  var onSelectExplore: ((UINavigationController) -> Void)?
  var onSelectFavorites: ((UINavigationController) -> Void)?
  var onSelectSearch: ((UINavigationController) -> Void)?

  private enum Tab {
    case explore, favorites, search
  }
  
  private let tabs: [Tab] = [.explore, .favorites, .search]

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    tabBar.tintColor = .label
    delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTabs()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    selectionChanged()
  }
  
  private func configureTabs() {
    viewControllers = tabs.map(createControllerFor)
  }
  
  private func createControllerFor(_ tab: Tab) -> UIViewController {
    switch tab {
    case .explore: return createExplore()
    case .favorites: return createFavorites()
    case .search: return createSearch()
    }
  }
  
  private func createExplore() -> UINavigationController {
    let nc = createNC()
    nc.tabBarItem.title = "Explore"
    nc.tabBarItem.image = UIImage.mve.popcornO
    nc.tabBarItem.selectedImage = UIImage.mve.popcornFilled
    return nc
  }
  
  private func createFavorites() -> UINavigationController {
    let nc = createNC()
    nc.tabBarItem.title = "Favorites"
    nc.tabBarItem.image = UIImage.mve.starO
    nc.tabBarItem.selectedImage = UIImage.mve.startFilled
    return nc
  }

  private func createSearch() -> UINavigationController {
    let nc = createNC()
    nc.tabBarItem.title = "Search"
    nc.tabBarItem.image = UIImage.mve.magnifyingGlass
    nc.tabBarItem.selectedImage = UIImage.mve.magnifyingGlassThick
    return nc
  }

  private func createNC() -> UINavigationController {
    let nc = UINavigationController()
    nc.navigationBar.tintColor = .label
    return nc
  }

  private func selectionChanged() {
    guard let viewControllers = self.viewControllers else { return }

    let tab = tabs[selectedIndex]
    let tabVC = viewControllers[selectedIndex]
    guard let nc = tabVC as? UINavigationController else {
      fatalError("Expecting navigation controller for '\(tab)' tab")
    }
    
    switch tab {
    case .explore: onSelectExplore?(nc)
    case .favorites: onSelectFavorites?(nc)
    case .search: onSelectSearch?(nc)
    }
  }
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    selectionChanged()
  }

}
