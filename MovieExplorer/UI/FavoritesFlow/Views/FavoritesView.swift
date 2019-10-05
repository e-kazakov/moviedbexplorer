//
//  FavoritesView.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 29.08.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class FavoritesView: UIView {
  
  let moviesListView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .appBackground
    return cv
  }()
  
  let initialView = FavoritesInitialView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
    hideAll(except: initialView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func showInitial() {
    guard initialView.isHidden else { return }

    hideAll(except: initialView)
  }
  
  func showList() {
    guard moviesListView.isHidden else { return }
    
    hideAll(except: moviesListView)
  }
  
  private func hideAll(except toShow: UIView) {
    mve.crossDissolveTransition {
      self.subviews.forEach { subview in
        subview.isHidden = true
      }
      toShow.isHidden = false
    }
  }
  
  private func setupSubviews() {
    addSubview(moviesListView)
    addSubview(initialView)

    moviesListView.translatesAutoresizingMaskIntoConstraints = false
    initialView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      moviesListView.topAnchor.constraint(equalTo: topAnchor),
      moviesListView.bottomAnchor.constraint(equalTo: bottomAnchor),
      moviesListView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
      moviesListView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
      
      initialView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      initialView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      initialView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
      initialView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
    ])
  }
  
}
