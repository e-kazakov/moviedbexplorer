//
//  FavoritesVC.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    configureNavigationItem()
    configureTabBarItem()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureNavigationItem() {
    title = "Favorites"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
  
  private func configureTabBarItem() {
    tabBarItem.title = "Favorites"
    tabBarItem.image = UIImage.tmdb.starO
    tabBarItem.selectedImage = UIImage.tmdb.startFilled
  }
  
}
