//
//  ListCell.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/24/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class ListCell: UICollectionViewCell {
  
  let listView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.horizontal)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    listView.translatesAutoresizingMaskIntoConstraints = false
    listView.backgroundColor = .appBackground

    contentView.addSubview(listView)
    
    NSLayoutConstraint.activate([
      listView.topAnchor.constraint(equalTo: contentView.topAnchor),
      listView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      listView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      listView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
    ])
  }
  
}
