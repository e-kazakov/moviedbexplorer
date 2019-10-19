//
//  Reusable.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 4/7/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

protocol Reusable {
  static var defaultReuseIdentifier: String { get }
}

extension Reusable {
  static var defaultReuseIdentifier: String {
    return String(describing: self)
  }
}

extension UICollectionReusableView: Reusable { }

extension UICollectionView {

  func register<T: UICollectionViewCell>(_: T.Type) {
    register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  func dequeueReusableCell<T: UICollectionViewCell>(
    _: T.Type,
    withReuseIdentifier identifier: String,
    for indexPath: IndexPath
  ) -> T {
    register(T.self, forCellWithReuseIdentifier: identifier)
    let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    guard let typedCell = cell as? T else {
      fatalError("Unexpected type of cell with identifier: \(identifier). Expecting \(T.self) got \(type(of: cell))")
    }
    
    return typedCell
  }
  
  func dequeueReusableCell<T: UICollectionViewCell>(
    _ type: T.Type,
    for indexPath: IndexPath
  ) -> T {
    return dequeueReusableCell(type, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath)
  }
  
}

extension UICollectionView {

  func register<T: UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind kind: String) {
    register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
    _: T.Type,
    ofKind kind: String,
    withReuseIdentifier identifier: String,
    forIndexPath indexPath: IndexPath
  ) -> T {
    register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
    guard let typedView = view as? T else {
        fatalError("Unexpected type of supplementary view with identifier: \(identifier)." +
          " Expecting \(T.self) got \(type(of: view))")
    }
    
    return typedView
  }
  
  func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
    _ type: T.Type,
    ofKind kind: String,
    forIndexPath indexPath: IndexPath
  ) -> T {
    return dequeueReusableSupplementaryView(
      type, ofKind: kind, withReuseIdentifier: T.defaultReuseIdentifier, forIndexPath: indexPath)
  }
  
}
