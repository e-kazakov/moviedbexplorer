//
//  RecentSearchQueryCell.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 20.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class RecentSearchQueryCell: UICollectionViewCell {
  
  var text: String? {
    get {
      return label.text
    }
    set {
      label.text = newValue
    }
  }
  
  private let label = UILabel()
  private let separator: UIView = {
    let separator = UIView()
    separator.backgroundColor = .appSeparator
    return separator
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    label.translatesAutoresizingMaskIntoConstraints = false
    separator.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(label)
    contentView.addSubview(separator)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: topAnchor),
      label.bottomAnchor.constraint(equalTo: bottomAnchor),
      label.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
      label.rightAnchor.constraint(equalTo: rightAnchor),

      separator.heightAnchor.constraint(equalToConstant: 1.0/UIScreen.main.scale),
      separator.bottomAnchor.constraint(equalTo: bottomAnchor),
      separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
      separator.rightAnchor.constraint(equalTo: rightAnchor),
    ])
  }
}

extension RecentSearchQueryCell: SizePreferrable {
  static func preferredSize(inContainer containerSize: CGSize) -> CGSize {
    CGSize(width: containerSize.width, height: 50)
  }
}
