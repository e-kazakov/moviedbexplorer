//
//  FirstViewController.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieSearchVC: UIViewController {

  init() {
    super.init(nibName: nil, bundle: nil)
    
    configureNavigationItem()
    configureTabBarItem()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureNavigationItem() {
    title = "Search"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
  
  private func configureTabBarItem() {
    tabBarItem.title = "Search"
    tabBarItem.image = UIImage.tmdb.magnifyingGlass
    tabBarItem.selectedImage = UIImage.tmdb.magnifyingGlassThick
  }

}
